#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics/data/traits_0.1miss
#SBATCH -J gwas_array10
#SBATCH -o /home/caryn89/slurm_logs/gwas10_%j.txt
#SBATCH -e /home/caryn89/slurm_logs/gwas10_%j.txt
#SBATCH -t 05:00:00
#SBATCH --mem 2000
#SBATCH --array=1-13

set -o
set -e

###########
# Modules #

###########
#   Data   #

# GBS bimbam
gbsBB="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s_F.bimbam"

gbsBBAnn="/home/caryn89/rotations/maize_genomics/data/traits/ZeaGBSv27_s_F.bimbam.ann"

# Phenotype BB
phenoBB="/home/caryn89/rotations/maize_genomics/data/phenotypes/ZeaGBS_phenotypes.bb"

# Trait information
traits="/home/caryn89/rotations/maize_genomics/data/phenotypes/traitList.txt"

# array information output file
out_info="/home/caryn89/rotations/maize_genomics/data/traits_0.1miss/array2trait.txt"

# relatedness matrix
rmat="ZeaGBSv27_sF_F"

# gemma lmm output

############
#   Main   #

#echo $SLURM_ARRAY_TASK_ID >> $out_info

awk -v x=$SLURM_ARRAY_TASK_ID '{printf "%s\t%s\n", '$SLURM_ARRAY_TASK_ID', $x}' $traits >> $out_info

t="$(awk -v x=$SLURM_ARRAY_TASK_ID '{print $x}' $traits)"
echo "${t}"

mkdir "${t}"
cd "${t}"
awk -v x=$SLURM_ARRAY_TASK_ID '{print $x}' $phenoBB > tmp$SLURM_ARRAY_TASK_ID\.txt

wc -l tmp$SLURM_ARRAY_TASK_ID\.txt
cat tmp$SLURM_ARRAY_TASK_ID\.txt

/home/emjo/apps/GEMMA/bin/gemma -g $gbsBB -p tmp$SLURM_ARRAY_TASK_ID\.txt -n 1 -gk 2 -miss 0.1 -o $rmat

/home/emjo/apps/GEMMA/bin/gemma -g $gbsBB -p tmp$SLURM_ARRAY_TASK_ID\.txt -a $gbsBBAnn -n 1 -lmm 4 -miss 0.1 -k output/$rmat\.sXX.txt -o ZeaGBSv27_"${t}"

