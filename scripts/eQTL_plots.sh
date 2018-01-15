#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_eQTL
#SBATCH -J eQTL_plots
#SBATCH -e /home/caryn89/slurm_logs/plots_eQTL_%j.txt
#SBATCH -o /home/caryn89/slurm_logs/plots_eQTL_%j.txt
#SBATCH -t 05:00:00
#SBATCH --mem 10000
#SBATCH --exclude=bigmem1,bigmem2,bigmem3

set -o
set -e

Rscript eQTL_manhattans.R 
echo $?


