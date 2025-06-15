#!/bin/bash
#SBATCH --job-name=linear_buckling
#SBATCH --output=logs/linear_buckling_%j.out
#SBATCH --error=logs/linear_buckling_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
# #SBATCH --mem=8G
#SBATCH --time=02:00:00
## SBATCH --partition=defq

# === [INFO] Load required modules ===
module purge
module load matlab/R2023b
module load nastran/2021

# === [INFO] Set working directory to repo root ===
cd $SLURM_SUBMIT_DIR

# === [INFO] Ensure logs directory exists ===
mkdir -p logs

# === [INFO] Print job environment (debugging) ===
echo "[INFO] Job ID       : $SLURM_JOB_ID"
echo "[INFO] Job Name     : $SLURM_JOB_NAME"
echo "[INFO] Node List    : $SLURM_JOB_NODELIST"
echo "[INFO] Submit Dir   : $SLURM_SUBMIT_DIR"
echo "[INFO] Running from : $(pwd)"

# === [INFO] Start MATLAB-based pipeline ===
matlab -nodisplay -nosplash -r "run('scripts/main/linear_buckling.m'); exit;"


