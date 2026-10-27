#!/bin/bash
# h2_dft.sh -- H2 potential energy curve with Quantum ESPRESSO
#
#   bash h2_dft.sh conv   -> convergence tests (cutoff and box size) at 0.74 A
#   bash h2_dft.sh far    -> stretched points (3 to 6 A) + atom reference tests
#   bash h2_dft.sh scan   -> the full curve: 23 distances, spin-restricted and
#                            spin-broken-symmetry, plus the isolated H atom
#
# Results are written as CSV files in the folder you run it from.
# All energies in the CSV files are in HARTREE (QE prints Rydberg; we divide by 2).

# ================= EDIT THESE LINES =================
PSEUDO_DIR=$HOME/Pseudo                 # folder that holds the pseudopotential files
H_PSEUDO=H.pbe-rrkjus_psl.1.0.0.UPF        # hydrogen pseudopotential file name
ECUT=60                                 # plane-wave cutoff (Ry), chosen from the "conv" test
ECUTRHO=480                             # density cutoff (Ry): 8 x ECUT for ultrasoft
CELL=24.0                               # cubic box side in BOHR (24 bohr = 12.7 Angstrom)
PW="mpirun -np 48 /home/tadeoye/q-e-qe-7.4.1/bin/pw.x"   # same pw.x as your W jobs
# ====================================================

DISTANCES="0.50 0.60 0.62 0.64 0.66 0.68 0.70 0.72 0.74 0.76 0.78 0.80 0.82 0.84 0.86 0.88 0.90 1.00 1.20 1.50 2.00 2.50 3.00"
EXTRA=""             # extra &system options (used for atom tests)
BOHR=0.529177        # Angstrom per bohr
HA_EV=27.211386

# --- H2 molecule. args: name distance(A) nspin(1 = restricted, 2 = spin-broken-symmetry)
write_h2 () {
  local name=$1 d=$2 ns=$3
  local c z1 z2
  c=$(awk -v L=$CELL -v b=$BOHR 'BEGIN{printf "%.6f", L*b/2}')
  z1=$(awk -v c=$c -v d=$d 'BEGIN{printf "%.6f", c-d/2}')
  z2=$(awk -v c=$c -v d=$d 'BEGIN{printf "%.6f", c+d/2}')
  if [ "$ns" = "1" ]; then
    SPIN="nspin=1"
    SPECIES=" H 1.008 $H_PSEUDO"
    NTYP=1; L1="H"; L2="H"
  else
    SPIN="nspin=2, tot_magnetization=0, starting_magnetization(1)=1.0, starting_magnetization(2)=-1.0"
    SPECIES=" H1 1.008 $H_PSEUDO
 H2 1.008 $H_PSEUDO"
    NTYP=2; L1="H1"; L2="H2"
  fi
  cat > $name.in <<EOF
&control
  calculation='scf', prefix='$name', outdir='./tmp_$name', pseudo_dir='$PSEUDO_DIR'
  disk_io='none'
/
&system
  ibrav=1, celldm(1)=$CELL, nat=2, ntyp=$NTYP
  ecutwfc=$ECUT, ecutrho=$ECUTRHO
  occupations='fixed', $SPIN
/
&electrons
  conv_thr=1.0d-8, mixing_beta=0.2, mixing_ndim=12, electron_maxstep=300
/
ATOMIC_SPECIES
$SPECIES
ATOMIC_POSITIONS angstrom
 $L1 $c $c $z1
 $L2 $c $c $z2
K_POINTS gamma
EOF
}

# --- one isolated H atom (one electron, spin up) in the same box
write_atom () {
  local name=$1
  local c
  c=$(awk -v L=$CELL -v b=$BOHR 'BEGIN{printf "%.6f", L*b/2}')
  cat > $name.in <<EOF
&control
  calculation='scf', prefix='$name', outdir='./tmp_$name', pseudo_dir='$PSEUDO_DIR'
  disk_io='none'
/
&system
  ibrav=1, celldm(1)=$CELL, nat=1, ntyp=1
  ecutwfc=$ECUT, ecutrho=$ECUTRHO
  occupations='fixed', nspin=2, tot_magnetization=1$EXTRA
/
&electrons
  conv_thr=1.0d-8, mixing_beta=0.2, mixing_ndim=12, electron_maxstep=300
/
ATOMIC_SPECIES
 H 1.008 $H_PSEUDO
ATOMIC_POSITIONS angstrom
 H $c $c $c
K_POINTS gamma
EOF
}

run_pw () { $PW -in $1.in > $1.out 2>&1; rm -rf tmp_$1; }

# energy in Hartree. If the loop did not reach conv_thr but its error estimate is
# below 2e-5 Ry (= 0.3 meV, negligible here) the last energy is accepted; else NaN.
get_E () {
  if grep -q 'convergence has been achieved' $1.out 2>/dev/null; then
    grep '^!' $1.out | tail -1 | awk '{printf "%.8f", $5/2}'
  else
    acc=$(grep 'estimated scf accuracy' $1.out 2>/dev/null | tail -1 | awk '{print $5}')
    if [ -n "$acc" ] && awk -v a=$acc 'BEGIN{exit !(a+0 < 2.0e-5)}'; then
      grep '^     total energy' $1.out | tail -1 | awk '{printf "%.8f", $4/2}'
    else
      echo NaN
    fi
  fi
}

de_ev () { awk -v a=$1 -v m=$2 'BEGIN{ if (a=="NaN"||m=="NaN") print "NaN"; else printf "%.4f", (2*a-m)*'$HA_EV' }'; }

do_conv () {
  mkdir -p h2_dft_conv; cd h2_dft_conv
  local ECUT0=$ECUT ECUTRHO0=$ECUTRHO CELL0=$CELL
  echo "--- cutoff test, box $CELL0 bohr, d = 0.74 A ---"
  echo "ecutwfc  E(H2) Ha      E(H) Ha       De (eV)"
  for ec in 30 40 50 60 80; do
    ECUT=$ec; ECUTRHO=$((ec*8))
    write_atom a_ec$ec; run_pw a_ec$ec
    write_h2 m_ec$ec 0.74 1; run_pw m_ec$ec
    ea=$(get_E a_ec$ec); em=$(get_E m_ec$ec)
    echo "$ec       $em   $ea   $(de_ev $ea $em)"
  done
  ECUT=$ECUT0; ECUTRHO=$ECUTRHO0
  echo "--- box test, ecutwfc $ECUT0, d = 0.74 A ---"
  echo "box(bohr)  E(H2) Ha      E(H) Ha       De (eV)"
  for L in 18 22 26 30; do
    CELL=$L
    write_atom a_box$L; run_pw a_box$L
    write_h2 m_box$L 0.74 1; run_pw m_box$L
    ea=$(get_E a_box$L); em=$(get_E m_box$L)
    echo "$L        $em   $ea   $(de_ev $ea $em)"
  done
  CELL=$CELL0
  cd ..
}

do_check () {
  mkdir -p h2_dft_check; cd h2_dft_check
  write_atom atom; run_pw atom
  write_h2 mol 0.74 1; run_pw mol
  ea=$(get_E atom); em=$(get_E mol)
  echo "ecutwfc=$ECUT  box=$CELL bohr"
  echo "E(H2) = $em Ha   E(H) = $ea Ha   De = $(de_ev $ea $em) eV"
  cd ..
}

do_far () {
  mkdir -p h2_dft_far; cd h2_dft_far
  echo "--- spin-broken H2 at large distance: should approach 2 x E(H) ---"
  echo "distance_A,E_spin_broken_Ha" > ../dft_far.csv
  for d in 3.00 4.00 5.00 6.00; do
    write_h2 s_$d $d 2; run_pw s_$d
    line="$d,$(get_E s_$d)"
    echo "$line"; echo "$line" >> ../dft_far.csv
  done
  echo "--- isolated H atom, three ways (energy in Ha) ---"
  local ECUT0=$ECUT ECUTRHO0=$ECUTRHO
  write_atom a1; run_pw a1; echo "a1 as in the scan:            $(get_E a1)"
  EXTRA=", starting_magnetization(1)=1.0"; write_atom a2; run_pw a2; EXTRA=""
  echo "a2 with starting magnet.:     $(get_E a2)"
  ECUT=80; ECUTRHO=640; write_atom a3; run_pw a3; ECUT=$ECUT0; ECUTRHO=$ECUTRHO0
  echo "a3 at 80 Ry:                  $(get_E a3)"
  cd ..
}

do_atom () {
  mkdir -p h2_dft_atom; cd h2_dft_atom
  local ECUT0=$ECUT ECUTRHO0=$ECUTRHO
  echo "--- isolated H atom and H2 (0.74 A) at high cutoffs ---"
  echo "ecutwfc  E(H2) Ha      E(H) Ha       De (eV)"
  for ec in 60 80 100 120; do
    ECUT=$ec; ECUTRHO=$((ec*8))
    write_atom a_$ec; run_pw a_$ec
    write_h2 m_$ec 0.74 1; run_pw m_$ec
    ea=$(get_E a_$ec); em=$(get_E m_$ec)
    echo "$ec       $em   $ea   $(de_ev $ea $em)"
  done
  ECUT=$ECUT0; ECUTRHO=$ECUTRHO0
  cd ..
}

do_scan () {
  mkdir -p h2_dft_run; cd h2_dft_run
  write_atom atom; run_pw atom
  EH=$(get_E atom)
  echo "H atom energy: $EH Ha"
  cd ..
  echo "E_H_atom_Ha,$EH" > dft_atom.csv
  echo "distance_A,E_restricted_Ha,E_spin_broken_Ha" > dft_curve.csv
  cd h2_dft_run
  for d in $DISTANCES; do
    write_h2 u_$d $d 1; run_pw u_$d
    write_h2 s_$d $d 2; run_pw s_$d
    line="$d,$(get_E u_$d),$(get_E s_$d)"
    echo "$line"
    echo "$line" >> ../dft_curve.csv
  done
  cd ..
  echo "Saved dft_curve.csv and dft_atom.csv"
}

case "$1" in
  conv) do_conv ;;
  check) do_check ;;
  far) do_far ;;
  atom) do_atom ;;
  scan) do_scan ;;
  *) echo "usage: bash h2_dft.sh conv | check | far | atom | scan" ;;
esac
