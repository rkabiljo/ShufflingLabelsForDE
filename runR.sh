#!/bin/bash -l
#SBATCH --output=R_permutations.%j.out
echo "starting R"
module load apps/R/3.6.0
prefix=$1
Rscript permutations.R $prefix 
echo "done with R"
