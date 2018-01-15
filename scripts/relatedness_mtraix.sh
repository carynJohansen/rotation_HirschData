#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics/data/expressed
#SBATCH -J exp_relMat
#SBATCH -e /home/caryn89/slurm_logs/exp_relMat_%j.txt
#SBATCH -o /home/caryn89/slurm_logs/exp_relMat_%j.txt
#SBATCH -t 03:00:00
#SBATCH --mem 5000
#SBATCH --exclude=bigmem1,bigmem2,bigmem3
 
set -o
set -e

###########
# Modules #

module load jdk/1.8
module load tassel
module load python/2.7.6

########
# DATA #

# raw GBS data
gbsRaw="/home/caryn89/rotations/maize_genomics/data/raw/ZeaGBSv27_publicSamples_imputedV5_AGPv3_20170206.h5"

#gbs Hapmap
#gbsHmp="/home/caryn89/rotations/maize_genomics/data/processed/ZeaGBSv27.hmp.txt"

# GBS filtered by genotypes
gbsL="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_s.hmp.txt"

# GBS filtered by minumum frequency
gbsLF="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_sF.hmp.txt"

gbstFVCF="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_sF.vcf"

expLinesT="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_503Exp_lines_T.txt"

expLines="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_503Exp_lines.txt"

phenoBB="/home/caryn89/rotations/maize_genomics/data/expressed/exp414.bb"

########
# MAIN #

#turn hdf5 into hapmap
# create hapmap only including desired taxa
#run_pipeline.pl -Xmx48g -fork1 -h5 $gbsRaw -fork2 -includeTaxaInFile $expLinesT -input1 -export $gbsL -exportType Hapmap -runfork1 -runfork2

# TEST: filter on minor allele frequency of 0.01
#run_pipeline.pl -Xmx20g -fork1 -h $gbsL -filterAlign -filterAlignMinCount 1 -filterAlignMinFreq 0.01 -export $gbsLF -runfork1

# Convert to VCF (unfiltered and filtered)
#run_pipeline.pl -Xmx20g -fork1 -h $gbsLF -export $gbstFVCF -exportType VCF -runfork1
#run_pipeline.pl -Xmx20g -fork1 -h $gbsSmall -export $gbsVCF -exportType VCF -runfork1

#VCFTOOLS

# TEST: filter on minor allele frequency of 0.01 using vcftools
#vcftools --vcf $gbsVCF --maf 0.01 --recode --out $gbsVCFf

#rename gbsVCFf
#gbsVCFf="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_sF.vcf.recode.vcf"

#COMPARE TESTS with vcftools
#vcftools --vcf $gbstFVCF --missing --out $vcf_tfiltered
#vcftools --vcf $gbsVCFf --missing --out $vcf_vfiltered

#vcftools --vcf $gbstSVCF --freq --out ZeaGBSv2_s_F_frequency
# Convert winning VCF to bimbami
gbsBB="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_s_vF.bimbam"
#python ~/scripts/vcf_to_bimbam.py -v $gbstFVCF -i $expLines -o $gbsBB -a

#GEMMA for relatedness

/home/caryn89/apps/GEMMA/bin/gemma -g $gbsBB -p $phenoBB -miss 0.1 -gk 2 -o ZeaGBSv27_sF

