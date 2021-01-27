#!/bin/bash
# generate events with clasdis

if [ -z "$SIMRGC" ]; then
  echo "ERROR: you must source env.sh first"; exit
fi

CLASDIS=${SIMRGC}/deps/clasdis/clasdis

idx=0
if [ $# -ge 1 ]; then idx=$1; fi

gendir="outgen/gen.${idx}"
mkdir -p $gendir
rm -r $gendir
mkdir -p $gendir
pushd $gendir

$CLASDIS \
--trig 20000 \
--nmax 10000

popd
