#!/bin/bash

export SIMRGC=$(dirname $(realpath $0))
export CLASDIS_PDF=${SIMRGC}/deps/clasdis/pdf/

export DISPIN_SIM=${SIMRGC}/../dispin
pushd $DISPIN_SIM
source env.sh
popd

