#!/bin/bash

idx=0
if [ $# -ge 1 ]; then idx=$1; fi

# settings ########################
gcard="steer/rgc_elmo_efficiency_0.gcard"
yamlfile="steer/rgc.yaml"
genfile="outgen/gen.lund"
simfile="outsim/sim.${idx}.hipo"

# output files
simfileEV=$(echo $simfile | sed 's/hipo$/evio/')
recfile=$(echo $simfile | sed 's/^outsim/outrec/')

# stdout divider
function sep { printf '%70s\n' | tr ' ' =; }
function banner { echo ""; sep; echo ">>  $1"; sep; }


# generator #######################
# NOTE: `outgen` will store generated data (on volatile)
banner "GENERATOR"
#cat pdvcs_hydrogen_11GeV_0_0_background.input > input.inp
#echo "RUN NUMBER ${i}" >> input.inp
#echo "SEED APPLY ${i}" >> input.inp
#genepi.exe input.inp
#cp events_prot_run${i}.dat outgen


# simulation ######################
banner "SIMULATION"
gemc $gcard \
-USE_GUI=0 \
-RUNNO=11 \
-INPUT_GEN_FILE="LUND, $genfile" \
-OUTPUT="EVIO, $simfileEV"
banner "evio2hipo"
evio2hipo -r 11 -t -1 -s -1 -o $simfile $simfileEV
# rm $simfileEV


# reconstruction ##################
banner "RECONSTRUCTION"
recon-util -c 2 -i $simfile -o $recfile -y $yamlfile
