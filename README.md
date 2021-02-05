# simRGC
simulations for RGC SIDIS

## setup
* clone with `--recurse-submodules`
* link `out...` directories to `/volatile` subdirectories
* compile `clasdis` in `src/clasdis` (`cd` there, then run `make`)
* set env vars with `source env.sh` (use `bash` or `zsh`)
  * if you want to connect `dispin` analysis code, make sure `$DISPIN_SIM` in `env.sh`
    points to the correct directory; if you do not want to use `dispin`, comment out
    the lines in `env.sh` so that `$DISPIN_SIM` does not get set

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
