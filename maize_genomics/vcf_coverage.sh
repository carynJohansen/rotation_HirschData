#!/bin/bash -l
#SBATCH -D /home/caryn89/rotations/maize_genomics
#SBATCH -o /home/caryn89/rotations/maize_genomics/runs/vcfcov-stdout-%j.txt
#SBATCH -e /home/caryn89/rotations/maize_genomics/runs/vcfcov-stdout-%j.txt
#SBATCH -J vcfcov
#SBATCH --time=20:00:00
#SBATCH --exclude=bigmem1,bigmem2
set -e
set -u

#get coverage for sites in the vcf
vcftools --vcf data/gemma_input/ZeaGBSv27_sF.vcf --missing --out data/gemma_input/Zea_all
#vcftools --vcf data/gemma_input/ZeaGBSv27_sF.vcf --missing-site --out data/gemma_input/Zea_all
#vcftools --vcf ../genos/cAll_gbs2.7_282_max2alleles.recode.vcf --missing --out ../genos/cAll_partialimpute
