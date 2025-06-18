#!/bin/bash
#SBATCH --job-name=linear_buckling
#SBATCH --output=logs/linear_buckling_%j.out
#SBATCH --error=logs/linear_buckling_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --partition=compute

# === [INFO] Load required modules ===
module purge
module load matlab
module load nastran

# === [INFO] Set working directory to repo root ===
cd $SLURM_SUBMIT_DIR

# === [INFO] Ensure logs directory exists ===
mkdir -p logs

# === [INFO] Start MATLAB-based pipeline ===
matlab -nodisplay -nosplash -r "run('scripts/main/linear_buckling.m'); exit;"
