#!/bin/bash
# generate events with clasdis

if [ -z "$SIMRGC" ]; then
  echo "ERROR: you must source env.sh first"; exit
fi

# ARGUMENTS
if [ $# -ne 2 ]; then echo "USAGE: $0 [idx] [numEvents]"; exit; fi
idx=$1 # index, for organizing clasdis output
nev=$2 # total number of events to generate


# determine how many events on proton and neutron targets,
# given fixed total number of events
echo "calculating number of events to generate per nucleon..."
root -b -q calculateNev.C'('$nev')' > tempo
nev_p=$(grep 'on proton' tempo | awk '{print $2}')
nev_n=$(grep 'on neutron' tempo | awk '{print $2}')
echo "total number of events to generate: $nev"
echo "   - number on proton target:  $nev_p"
echo "   - number on neutron target: $nev_n"
rm tempo

# clasdis binary
CLASDIS=${SIMRGC}/deps/clasdis/clasdis

# output directory
outdir="${SIMRGC}/outgen/clasdis.${idx}"
mkdir -p $outdir
rm -r $outdir
mkdir -p $outdir

# nucleon loop
for nuc in proton neutron; do

  # create directory for lund files
  gendir="${SIMRGC}/outgen/tmp/gen.${idx}.${nuc}"
  mkdir -p $gendir
  rm -r $gendir
  mkdir -p $gendir
  pushd $gendir
  mkdir eventfiles

  # configure clasdis
  [[ "$nuc" == "proton" ]] && ngen=$nev_p || ngen=$nev_n
  PARAMS=(
    --trig $ngen   # number of events to generate
    --nmax 10000   # number of events per lund file
    --targ $nuc    # target species
    --zwidth 5     # target depth [cm]
    --trad 13      # target radius [cm]
    --raster 5     # target raster diameter [cm]
    --zpos 0       # target position [cm]
    --beam 10.6    # beam energy [GeV]
    --z 0.15       # minumum z = Epi/nu
  )

  # generate events
  echo "GENERATING $ngen EVENTS on $nuc target..."
  $CLASDIS ${PARAMS[@]} > ${outdir}/log.${nuc}.txt

  # move lund files to final output directory
  sleep 1
  mv eventfiles/*.dat ${outdir}/
  popd

done
echo "LUND files and LOGS written to $outdir"
echo "done!"
