#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics
#SBATCH -o /home/caryn89/rotations/maize_genomics/runs/rel-%j.out
#SBATCH -e /home/caryn89/rotations/maize_genomics/runs/rel-%j.err
#SBATCH -J relatedness
#SBATCH -t 01:00:00
#SBATCH --mem 4000
#SBATCH --exclude=bigmem1,bigmem2,bigmem3

set -o
set -e


data="/home/caryn89/rotations/maize_genomics/data/"
geno="gemma_input/ZeaGBSv27_sF.bb"
pheno="phenotypes/ZeaGBS_phenotypes.bb"

output="/home/caryn89/rotations/maize_genomics/data/output/"

ls $data
ls -la $data$geno
ls -la $data$pheno

/home/emjo/apps/GEMMA/bin/gemma -g $data$geno -p $data$pheno -n 1 -gk 2 -o ZeaGBS_sF4

