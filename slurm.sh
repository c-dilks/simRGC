#!/bin/bash


jobsuffix="init"
joblist=jobscript/joblist.${jobsuffix}.slurm
> $joblist
echo simu.sh 0 >> $joblist

slurm=jobscript/job.${jobsuffix}.slurm
> $slurm

function app { echo "$1" >> $slurm; }

app "#!/bin/bash"

app "#SBATCH --job-name=simRGC_simu"
app "#SBATCH --account=clas12"
app "#SBATCH --partition=production"

app "#SBATCH --mem-per-cpu=2000"
app "#SBATCH --time=2:00:00"

app "#SBATCH --array=1-$(cat $joblist | wc -l)"
app "#SBATCH --ntasks=1"

app "#SBATCH --output=/farm_out/%u/%x-%j-%N.out"
app "#SBATCH --error=/farm_out/%u/%x-%j-%N.err"

app "srun \$(head -n\$SLURM_ARRAY_TASK_ID $joblist | tail -n1)"


# launch jobs
printf '%70s\n' | tr ' ' -
echo "JOB LIST: $joblist"
cat $joblist
printf '%70s\n' | tr ' ' -
echo "JOB DESCRIPTOR: $slurm"
cat $slurm
printf '%70s\n' | tr ' ' -
exit # exit before job submission (for testing)
echo "submitting to slurm..."
sbatch $slurm
squeue -u `whoami`
