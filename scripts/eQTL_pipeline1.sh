#!/bin/bash -l

#SBATCH -D /home/caryn89/rotations/maize_eQTL/data/eQTL
#SBATCH -J eQTL
#SBATCH -e /home/caryn89/slurm_logs/eQTL_%j.txt
#SBATCH -o /home/caryn89/slurm_logs/eQTL_%j.txt
#SBATCH -t 00:30:00
#SBATCH --mem 5000
#SBATCH --array=1-15206

set -o
set -e

start=$(date +%s)

############
# MODEULES #

############
#   DATA   #

# use the already made GBS data for 
filteredDATA="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_s_vF.bimbam"

filteredANN="/home/caryn89/rotations/maize_genomics/data/expressed/ZeaGBSv27_s_vF.bimbam.ann"


# FPKM dataset for genes, where each column is a gene, each row is a maize line
# dimensions should be 

fpkm414="/home/caryn89/rotations/maize_eQTL/data/input/maize_414_expressedFPKM.bb"

#list of genes
genes="/home/caryn89/rotations/maize_eQTL/data/input/genes.txt"

#keep track of which array id goes to which gene
out_info="/home/caryn89/rotations/maize_eQTL/data/array2gene.txt"

# relatedness matrix
rmat="/home/caryn89/rotations/maize_eQTL/data/input/ZeaGBSv27_FPKM.sXX.txt"
#rmat="ZeaGBSv27_FPKM"

############
#   MAIN   #

awk -v x=$SLURM_ARRAY_TASK_ID '{printf "%s\t%s\n", '$SLURM_ARRAY_TASK_ID', $x}' $genes >> $out_info

g="$(awk -v x=$SLURM_ARRAY_TASK_ID '{print $x}' $genes)"
echo "${g}"

mkdir -p "${g}"
cd "${g}"

awk -v x=$SLURM_ARRAY_TASK_ID '{print $x}' $fpkm414 > tmp$SLURM_ARRAY_TASK_ID\.txt

wc -l tmp$SLURM_ARRAY_TASK_ID\.txt

#only needed to do this once
#/home/emjo/apps/GEMMA/bin/gemma -g $filteredDATA -p tmp$SLURM_ARRAY_TASK_ID\.txt -n 1 -miss 0.1 -gk 2 -o $rmat

/home/emjo/apps/GEMMA/bin/gemma -g $filteredDATA -p tmp$SLURM_ARRAY_TASK_ID\.txt -a $filteredANN -miss 0.1 -n 1 -lmm 4 -k $rmat -o ZeaGBSv27_"${g}"

end=$(date +%s)
echo "TIME ELAPSED"
echo $(($end - $start))

