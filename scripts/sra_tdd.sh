#!/bin/bash -l

#SBATCH -D /home/caryn89/genomes
#SBATCH -J tdd_sra
#SBATCH -o /home/caryn89/slurm_logs/tdd_%j.out
#SBATCH -e /home/caryn89/slurm_logs/tdd_%j.out
#SBATCH --time=24:00:00
#SBATCH --mem=10000

set -e
set -u

module load sratoolkit


fastq-dump --outdir tripsicum_dactyloides/ --gzip --skip-technical --readids --read-filter pass --dumpbase --split-files --clip SRR447807
