#!/usr/bin/env bash
# H2 potential energy curve with DFT (Quantum ESPRESSO) - local computer version.
# Usage:  bash h2_dft_local.sh  test | conv | scan | far
# Optional settings (put before the command):  NP=4  PSEUDO_DIR=/path  PW_X=/path/to/pw.x
set -u

PSEUDO_DIR="${PSEUDO_DIR:-$HOME/Pseudo}"
H_PSEUDO="H.pbe-rrkjus_psl.1.0.0.UPF"
ECUT=60; ECUTRHO=480; CELL=24.0            # Ry, Ry, bohr (12.7 Angstrom box)
DISTANCES="0.50 0.60 0.62 0.64 0.66 0.68 0.70 0.72 0.74 0.76 0.78 0.80 0.82 0.84 0.86 0.88 0.90 1.00 1.20 1.50 2.00 2.50 3.00"

NP="${NP:-$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)}"
PW="${PW_X:-pw.x}"
if [ "$NP" -gt 1 ] && command -v mpirun >/dev/null 2>&1; then RUN="mpirun -np $NP $PW"; else RUN="$PW"; fi

OUT="$PWD/h2_dft_run"; mkdir -p "$OUT"

write_h2 () {  # file  distance(A)  nspin(1|2)  ecutwfc  ecutrho
  local f=$1 d=$2 ns=$3 ec=$4 er=$5 z1 z2
  z1=$(awk -v d="$d" 'BEGIN{printf "%.6f", 6.35 - d/2}')
  z2=$(awk -v d="$d" 'BEGIN{printf "%.6f", 6.35 + d/2}')
  {
    echo "&CONTROL"
    echo "  calculation='scf', prefix='h2', outdir='$OUT/tmp_$(basename "$f" .in)', pseudo_dir='$PSEUDO_DIR', disk_io='none'"
    echo "/"
    echo "&SYSTEM"
    if [ "$ns" = 1 ]; then
      echo "  ibrav=1, celldm(1)=$CELL, nat=2, ntyp=1, ecutwfc=$ec, ecutrho=$er, occupations='fixed'"
    else
      echo "  ibrav=1, celldm(1)=$CELL, nat=2, ntyp=2, ecutwfc=$ec, ecutrho=$er, occupations='fixed'"
      echo "  nspin=2, tot_magnetization=0, starting_magnetization(1)=1.0, starting_magnetization(2)=-1.0"
    fi
    echo "/"
    echo "&ELECTRONS"
    echo "  conv_thr=1.0d-8, mixing_beta=0.2, mixing_ndim=12, electron_maxstep=300"
    echo "/"
    echo "ATOMIC_SPECIES"
    if [ "$ns" = 1 ]; then
      echo " H 1.00794 $H_PSEUDO"
    else
      echo " H1 1.00794 $H_PSEUDO"
      echo " H2 1.00794 $H_PSEUDO"
    fi
    echo "ATOMIC_POSITIONS angstrom"
    if [ "$ns" = 1 ]; then
      echo " H 6.35 6.35 $z1"; echo " H 6.35 6.35 $z2"
    else
      echo " H1 6.35 6.35 $z1"; echo " H2 6.35 6.35 $z2"
    fi
    echo "K_POINTS gamma"
  } > "$f"
}

get_E () {  # prints energy in Hartree (Ry/2), or NaN
  awk '
    /^!/ {e=$5; done=1}
    /^ +total energy +=/ {last=$4}
    /estimated scf accuracy/ {acc=$5}
    END {
      if (done) printf "%.8f\n", e/2;
      else if (last != "" && acc != "" && acc+0 < 2e-5) printf "%.8f\n", last/2;
      else print "NaN"
    }' "$1"
}

run_one () {  # name  distance  nspin  ecutwfc  ecutrho  -> prints energy (Ha)
  local name=$1 d=$2 ns=$3 ec=$4 er=$5
  write_h2 "$OUT/$name.in" "$d" "$ns" "$ec" "$er"
  $RUN -in "$OUT/$name.in" > "$OUT/$name.out" 2>&1
  get_E "$OUT/$name.out"
  rm -rf "$OUT/tmp_$name"
}

mode="${1:-}"
case "$mode" in
  test)   # one distance, both settings: a quick check of the whole set-up
    echo "ecut=$ECUT/$ECUTRHO Ry, cores=$NP"
    echo "restricted   0.74 A: $(run_one t_res 0.74 1 $ECUT $ECUTRHO) Ha   (Thomas got -1.16654130)"
    echo "spin-broken  0.74 A: $(run_one t_sb  0.74 2 $ECUT $ECUTRHO) Ha   (Thomas got -1.16654419)"
    ;;
  conv)   # energy at 0.74 A for four cutoffs (ecutrho = 8 x ecutwfc)
    echo "cutoff_Ry,energy_Ha" | tee "$OUT/dft_conv.csv"
    for ec in 40 50 60 80; do
      echo "$ec,$(run_one c_$ec 0.74 1 $ec $((ec*8)))" | tee -a "$OUT/dft_conv.csv"
    done
    ;;
  scan)   # the main curve: every distance, restricted and spin-broken
    echo "distance_A,restricted_Ha,spinbroken_Ha" > "$OUT/dft_curve.csv"
    for d in $DISTANCES; do
      r=$(run_one "r_$d" "$d" 1 $ECUT $ECUTRHO)
      s=$(run_one "s_$d" "$d" 2 $ECUT $ECUTRHO)
      echo "$d,$r,$s" | tee -a "$OUT/dft_curve.csv"
    done
    ;;
  far)    # one stretched point, 4.0 A, spin-broken only (for the binding energy)
    echo "distance_A,spinbroken_Ha" > "$OUT/dft_far.csv"
    echo "4.00,$(run_one s_4.00 4.00 2 $ECUT $ECUTRHO)" | tee -a "$OUT/dft_far.csv"
    ;;
  *) echo "usage: bash h2_dft_local.sh test|conv|scan|far"; exit 1 ;;
esac
