#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_genomics/data/module_gwas_0.1miss
#SBATCH -J module_gwas_miss
#SBATCH -o /home/caryn89/slurm_logs/gemma_%j.txt
#SBATCH -e /home/caryn89/slurm_logs/gemma_%j.txt
#SBATCH -t 05:00:00
#SBATCH --mem 2000
#SBATCH --array=1-15

set -o
set -e

############
#   Data   #

# GBS bimbam
gbsBB="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_s_vF.bimbam"

gbsBBAnn="/home/caryn89/rotations/maize_genomics/data/module_gwas/ZeaGBSv27_s_vF.bimbam.ann"

# Phenotype BB
phenoBB="/home/caryn89/rotations/maize_genomics/data/module_gwas_0.1miss/292_MEs.bb"

# Trait information
traits="/home/caryn89/rotations/maize_genomics/data/module_gwas/module_list.txt"

# array information output file
out_info="/home/caryn89/rotations/maize_genomics/data/module_gwas_0.1miss/array2trait.txt"

# relatedness matrix
rmat="ZeaGBSv27_sF"

# gemma lmm output

############
#   Main   #

awk -v x=$SLURM_ARRAY_TASK_ID '{printf "%s\t%s\n", '$SLURM_ARRAY_TASK_ID', $x}' $traits >> $out_info

t="$(awk -v x=$SLURM_ARRAY_TASK_ID '{print $x}' $traits)"
echo "${t}"

mkdir -p "${t}"
cd "${t}"

awk -v x=$SLURM_ARRAY_TASK_ID '{print $x}' $phenoBB > tmp$SLURM_ARRAY_TASK_ID\.txt

wc -l tmp$SLURM_ARRAY_TASK_ID\.txt
cat tmp$SLURM_ARRAY_TASK_ID\.txt

echo $gbsBB
echo tmp$SLURM_ARRAY_TASK_ID\.txt
echo $traits
echo $phenoBB
echo $out_info
echo $rmat
echo "this is a test"

/home/emjo/apps/GEMMA/bin/gemma -g $gbsBB -p tmp$SLURM_ARRAY_TASK_ID\.txt -n 1 -miss 0.1 -gk 2 -o $rmat

/home/emjo/apps/GEMMA/bin/gemma -g $gbsBB -p tmp$SLURM_ARRAY_TASK_ID\.txt -a $gbsBBAnn -miss 0.1 -n 1 -lmm 4 -k output/$rmat\.sXX.txt -o ZeaGBSv27_"${t}"

