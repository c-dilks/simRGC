#!/bin/bash

if [ -z "$SIMRGC" ]; then
  echo "ERROR: you must source env.sh first"; exit
fi

# ARGUMENTS
if [ $# -lt 1 ]; then echo "USAGE: $0 [idx]"; exit; fi
idx=$1


# prepare output directories
simdir="${SIMRGC}/outsim/${idx}"
recdir="${SIMRGC}/outrec/${idx}"
mkdir -p $simdir; rm -r $simdir; mkdir -p $simdir
mkdir -p $recdir; rm -r $recdir; mkdir -p $recdir


# loop through lund files and build list of jobs
joblist=jobscript/joblist.${idx}.slurm
> $joblist
for lundfile in ${SIMRGC}/outgen/clasdis.${idx}/*.dat; do
  echo "./simu.sh $idx $lundfile" >> $joblist
done


# build job script
slurm=jobscript/job.${idx}.slurm
> $slurm

function app { echo "$1" >> $slurm; }

app "#!/bin/bash"

app "#SBATCH --job-name=simRGC_simu"
app "#SBATCH --account=clas12"
app "#SBATCH --partition=production"

app "#SBATCH --mem-per-cpu=2000"
app "#SBATCH --time=12:00:00"

app "#SBATCH --array=1-$(cat $joblist | wc -l)"
app "#SBATCH --ntasks=1"

app "#SBATCH --output=/farm_out/%u/%x-%j-%N.out"
app "#SBATCH --error=/farm_out/%u/%x-%j-%N.err"

app "srun \$(head -n\$SLURM_ARRAY_TASK_ID $joblist | tail -n1)"


# launch jobs
printf '%70s\n' | tr ' ' -
echo "JOB LIST: $joblist"
printf '%70s\n' | tr ' ' -
echo "JOB DESCRIPTOR: $slurm"
cat $slurm
printf '%70s\n' | tr ' ' -
#exit # exit before job submission (for testing)
echo "submitting to slurm..."
sbatch $slurm
squeue -u `whoami`
