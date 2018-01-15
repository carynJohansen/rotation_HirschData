#!/bin/bash -l
#SBATCH -D /home/caryn89
#SBATCH -o /home/caryn89/slurm_logs/iplant_pull_%j.out
#SBATCH -e /home/caryn89/slurm_logs/iplant_pull_%j.err
#SBATCH -J iplant
#SBATCH --time=20:00:00
#SBATCH --exclude=bigmem1,bigmem2
set -e
set -u

module load icommands

output_path="/home/caryn89/rotations/maize_genomics/data"

iget /iplant/home/shared/panzea/genotypes/GBS/v27/ZeaGBSv27_publicSamples_imputedV5_AGPv3_20170206.h5 $output_path

