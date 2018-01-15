#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics
#SBATCH -J lmm
#SBATCH -e /home/caryn89/rotations/maize_genomics/runs/lmm-%j.err
#SBATCH -o /home/caryn89/rotations/maize_genomics/runs/lmm-%j.out
#SBATCH -t 01:00:00
#SBATCH --mem 4000

set -o
set -e

data="/home/caryn89/rotations/maize_genomics/data/"
geno="gemma_input/ZeaGBSv27_sF.bb"
pheno="phenotypes/ZeaGBS_phenotypes.bb"
kin="gemma_input/ZeaGBS_sF.sXX.txt"

/home/emjo/apps/GEMMA/bin/gemma -g $data$geno -p $data$pheno -lmm 4 -k $data$kin -o ZeaGBSv27_sF_lmm

