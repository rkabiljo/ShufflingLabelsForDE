# ShufflingLabelsForDE
shuffle labels of cases / controls to assess whether pValues are due to chance

## files needed
You need an expression matrix and the accompanying phenotype table. Adapt:
<br>
1.the labels inside the script to match your phenotype (e.g. Status, Age)
<br>
2.the formula for sample design to reflect the main category and covariates



## On Rosalind I ran it like this <br>

'''
sbatch -p brc --mem=10G runR.sh A
sbatch -p brc --mem=10G runR.sh B
sbatch -p brc --mem=10G runR.sh C
'''

'A' is a prefix for output file.  I did it becasue I split it in 100 random permutations, and the results of each one will be written to a different file, e.g. significantPermutationsA11.41.13.csv.  I sent 10 jobs with different prefix letters so that they could run at once.

# Merge the output files 


