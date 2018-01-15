#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics
#SBATCH -J vcfmissing
#SBATCH -e /home/caryn89/slurm_logs/vcfmissing_%j.txt
#SBATCH -o /home/caryn89/slurm_logs/vcfmissing_%j.txt
#SBATCH -t 01:00:00
#SBATCH --mem 5000
#SBATCH --exclude=bigmem1,bigmem2,bigmem3

set -e
set -o

# the pipeline for 

###########
# Modules #

module load jdk/1.8
module load tassel
module load python/2.7.6

############
#   DATA   #

# raw GBS data
gbsRaw="/home/caryn89/rotations/maize_genomics/data/raw/ZeaGBSv27_publicSamples_imputedV5_AGPv3_20170206.h5"

#gbs Hapmap
#gbsHmp="/home/caryn89/rotations/maize_genomics/data/processed/ZeaGBSv27.hmp.txt"

# GBS filtered by genotypes
gbsL="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s.hmp.txt"

# GBS filtered by minumum frequency
gbsLF="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_sF.hmp.txt"

# GBS filtered by expression/completedness

# GBS vcf
gbsVCF="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s.vcf"

# vcf missing data
vcfPrefix="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s_vcfInfo"
vcfPrefixF="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s_F_vcfInfo"

# GBS vcf filtered to missing values
vcfF="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s_F"

# GBS bimbam
gbsBB="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s_F.bimbam"

# phenotype matrix

# phenotype line list
# for tassel filtering:
zeaLinesTassel="/home/caryn89/rotations/maize_genomics/data/phenotypes/ZeaGBS_phenotypeLines_c_T.txt"

zeaLinesPy="/home/caryn89/rotations/maize_genomics/data/phenotypes/ZeaGBS_phenotypeLines_c.txt"

phenoBB="/home/caryn89/rotations/maize_genomics/data/phenotypes/ZeaGBS_phenotypes.bb"

# relatedness matrix
gbsR="ZeaGBSv27_s_F"

# gemma lmm output file

############
#   MAIN   #

# get raw data (if not already, via icommands)

# filter raw data by phenotype lines
# tassel
echo $gbsRaw
echo $zeaLinesTassel
echo $gbsHmp

#make HDF5 into a hapmap
#run_pipeline.pl -Xmx48g -fork1 -h5 $gbsRaw -fork2 -includeTaxaInFile $zeaLinesTassel -input1 -export $gbsL -exportType Hapmap -runfork1 -runfork2 


# filter by allele frequency
echo $gbsL
echo $gbsLF
#run_pipeline.pl -Xmx20g -fork1 -h $gbsL -filterAlign -filterAlignMinCount 1 -filterAlignMinFreq 0.01 -export $gbsLF -runfork1

# convert hampmap to vcf
# tasse
#echo $gbsLF
#echo $gbsVCF
#run_pipeline.pl -Xmx20g -fork1 -h $gbsL -export $gbsVCF -exportType VCF -runfork1

# look at vcf for missing values (--missing)
#vcftools
#echo $vcfPrefix
#vcftools --vcf $gbsVCF --missing --out $vcfPrefix

# get the raw allele counts for each loci
#vcftools --vcf $gbsVCF --counts --out $vcfPrefix

# filter vcf away from missing values (-maf)
#echo $gbsVCF
#echo $vcfF
#vcftools --vcf $gbsVCF --maf 0.01 --recode --out $vcfF

vcfF="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s_F.recode.vcf"
#echo $vcfF
#vcftools --vcf $vcfF --missing --out $vcfPrefixF
#vcftools --vcf $vcfF --counts --out $vcfPrefixF

#vcftools

# convert vcf to bimbam file
# custom python
#mkdir BBAnnotation
echo $gbsVCF
python ~/scripts/vcf_to_bimbam.py -v $vcfF -i $zeaLinesPy -o $gbsBB -a

# gemma to create relatedness matrix
# loop through phenotype file
 
#/home/emjo/apps/GEMMA/bin/gemma -g $gbsBB -p $phenoBB -n 1 -gk 2 -o $gbsR

# gemma to run lmm

