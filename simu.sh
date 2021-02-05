#!/bin/bash

if [ -z "$SIMRGC" ]; then
  echo "ERROR: you must source env.sh first"; exit
fi

# ARGUMENTS
if [ $# -lt 2 ]; then echo "USAGE: $0 [idx] [lund file]"; exit; fi
idx=$1
lundfile=$2


# settings ########################
gcard="steer/rgc_elmo.gcard"
yamlfile="steer/rgc.yaml"

# output files
# - gemc output evio and hipo -> outsim
# - cooked hipo -> outrec
simdir="${SIMRGC}/outsim/${idx}"
recdir="${SIMRGC}/outrec/${idx}"
mkdir -p $simdir
mkdir -p $recdir
simfile="${simdir}/$(basename $lundfile .dat).hipo"
simfileEV=$(echo $simfile | sed 's/hipo$/evio/')
recfile=${recdir}/$(basename $simfile)

# print job details
echo "idx = $idx"
echo "lundfile = $lundfile"
echo "gcard = $gcard"
echo "yamlfile = $yamlfile"
echo "simfile = $simfile"
echo "simfileEV = $simfileEV"
echo "recfile = $recfile"

# stdout divider
function sep { printf '%70s\n' | tr ' ' =; }
function banner { echo ""; sep; echo ">>  $1"; sep; }


# simulation ######################
banner "SIMULATION"
gemc $gcard \
-USE_GUI=0 \
-RUNNO=11 \
-PRINT_EVENT=10 \
-INPUT_GEN_FILE="LUND, $lundfile" \
-OUTPUT="evio, $simfileEV"
sleep 3
rm -v $lundfile


# evio -> hipo ####################
banner "evio2hipo"
evio2hipo -r 11 -t -1 -s -1 -o $simfile $simfileEV
sleep 3
rm -v $simfileEV


# reconstruction ##################
banner "RECONSTRUCTION"
recon-util -c 2 -i $simfile -o $recfile -y $yamlfile
sleep 3
rm -v $simfile


# dihadron analysis ###############
banner "ANALYSIS"
if [ -n "$DISPIN_SIM" ]; then
  pushd $DISPIN_SIM
  runDiskim.sh $recfile mcrec skim
  popd
  sleep 3
  rm -v $recfile
else
  echo "analysis step disabled"
fi


banner "DONE"
