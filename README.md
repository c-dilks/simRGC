# simRGC
simulations for RGC SIDIS

## setup
* clone with `--recurse-submodules`
* link `out...` directories to `/volatile` subdirectories
* compile `clasdis` in `src/clasdis` (`cd` there, then run `make`)
* set env vars with `source env.sh` (use `bash` or `zsh`)

## usage
- generate events with `clasdis`:
  - call `generate.sh [idx] [numEvents]`, where `idx` is a unique name for this dataset, and
    `numEvents` specifies the total number of events to generate (it will automatically
    determine how many to generate on proton and neutron targets)
  - output is to `outgen/`
- run `gemc`, decode and reconstruct:
  - call `slurm.sh [idx]` to run on slurm, which parallelizes 
    `simu.sh [idx] [lundfile]`, the main script
  - output of `gemc` is stored in `outsim`; after subsequent reconstruction, these data
    are deleted
  - reconstructed data are stored in `outrec`, ready to be sent to analysis code
