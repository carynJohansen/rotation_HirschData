#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics/data/module_gwas
#SBATCH -J bimbam_making 
#SBATCH -o /home/caryn89/slurm_logs/BB_%j.txt
#SBATCH -e /home/caryn89/slurm_logs/BB_%j.txt
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

############
#   DATA   #

gbsRaw="/home/caryn89/rotations/maize_genomics/data/raw/ZeaGBSv27_publicSamples_imputedV5_AGPv3_20170206.h5"

gbsSmall="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_s.hmp.txt"

#filtered by tassel
gbstF="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_stF.hmp.txt"

# GBS converted into a VCF
gbstFVCF="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_stF.vcf"

#non-MAF filtered
gbsVCF="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_s.vcf"

#MAF filtered by vcftools
gbsVCFf="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_sF.vcf"

# file prefixed for GBS VCF missing data information
vcf_tfiltered="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_stF_vcfInfo"
vcf_vfiltered="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_sF_vcfInfo"

# Maize information

#phenotype-based list of maize lines for filtering by taxa in tassel
# this is a return separated text file
taxaTassel="/home/caryn89/rotations/maize_genomics/data/module_gwas/maize_304_GBS_c_T.txt"

#for converstion to bimbam
taxaPy="/home/caryn89/rotations/maize_genomics/data/module_gwas/maize_304_GBS_c.txt"

#Bimbam output
gbsBB="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_sF.bimbam"


############
#   MAIN   #

#TASSEL

echo $gbsRaw
echo $taxaTassel
echo $gbsSmall

#turn hdf5 into hapmap
# create hapmap only including desired taxa
run_pipeline.pl -Xmx48g -fork1 -h5 $gbsRaw -fork2 -includeTaxaInFile $taxaTassel -input1 -export $gbsSmall -exportType Hapmap -runfork1 -runfork2

# TEST: filter on minor allele frequency of 0.01
#run_pipeline.pl -Xmx20g -fork1 -h $gbsSmall -filterAlign -filterAlignMinCount 1 -filterAlignMinFreq 0.01 -export $gbstF -runfork1

# Convert to VCF (unfiltered and filtered)
#run_pipeline.pl -Xmx20g -fork1 -h $gbstF -export $gbstFVCF -exportType VCF -runfork1
#run_pipeline.pl -Xmx20g -fork1 -h $gbsSmall -export $gbsVCF -exportType VCF -runfork1

#VCFTOOLS

# TEST: filter on minor allele frequency of 0.01 using vcftools
#vcftools --vcf $gbsVCF --maf 0.01 --recode --out $gbsVCFf

#rename gbsVCFf
gbsVCFf="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_sF.vcf.recode.vcf"

#COMPARE TESTS with vcftools
#vcftools --vcf $gbstFVCF --missing --out $vcf_tfiltered
#vcftools --vcf $gbsVCFf --missing --out $vcf_vfiltered

vcftools --vcf $gbsVCFf --freq --out ZeaGBSv2_s_F_frequency

###### STOP here to compare and see if they are different

# Convert winning VCF to bimbami
gbsBB="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_s_vF.bimbam"
python ~/scripts/vcf_to_bimbam.py -v $gbsVCFf -i $taxaPy -o $gbsBB -a

