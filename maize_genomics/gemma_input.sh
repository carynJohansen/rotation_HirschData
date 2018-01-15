#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics
#SBATCH -o /home/caryn89/rotations/maize_genomics/runs/vcf2bimbam-%j.out
#SBATCH -e /home/caryn89/rotations/maize_genomics/runs/vcf2bimbam-%j.err
#SBATCH -J vcf2bimbam
#SBATCH -t 01:00:00
#SBATCH --mem 4000
#SBATCH --exclude=bigmem1,bigmem2,bigmem3

set -o
set -e

module load python/2.7.6

data="/home/caryn89/rotations/maize_genomics/data/gemma_input/"
ind="ZeaGBS_phenotypeLines.txt"
vcf="ZeaGBSv27_sF.vcf"
bb="ZeaGBSv27_sF.bb"

ls $data
ls -la $data$vcf
ls -la $data$ind

python ~/scripts/vcf_to_bimbam.py -v $data$vcf -i $data$ind -o $data$bb

