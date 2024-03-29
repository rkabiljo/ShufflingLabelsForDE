# ShufflingLabelsForDE
shuffle labels of cases / controls to assess whether pValues are due to chance

## files needed
You need an expression matrix and the accompanying phenotype table. Adapt:
<br>
1.the labels inside the script to match your phenotype (e.g. Status, Age)
<br>
2.the formula for sample design to reflect the main category and covariates



## On Rosalind I ran it like this <br>

```
sbatch -p brc --mem=10G runR.sh A
sbatch -p brc --mem=10G runR.sh B
sbatch -p brc --mem=10G runR.sh C
```

'A' is a prefix for output file.  I did it becasue I split it in 100 random permutations, and the results of each one will be written to a different file, e.g. significantPermutationsA11.41.13.csv.  I sent 10 jobs with different prefix letters so that they could run at once.

# Merge the output files and look at results
<br>this is also in script countingPermutationsFromCsvRes.R<br>

Go to the directory where all csv files from previous step are

From R:

```
files <- list.files(pattern = "\\.csv$")
files
```
<br>In my case I got something like this, a list of all of them:

<br>              [1] "significantPermutationsB19.40.57.csv"
<br>                 [2] "significantPermutationsC19.28.36.csv"
<br>                 [3] "significantPermutationsD20.02.40.csv"
<br>                 [4] "significantPermutationsE20.02.39.csv"
<br>                 [5] "significantPermutationsF20.06.08.csv"
<br>                 [6] "significantPermutationsG20.05.04.csv"
<br>                 [7] "significantPermutationsH20.04.42.csv"
<br>                 [8] "significantPermutationsK19.29.54.csv"
<br>                 [9] "significantPermutationsL19.55.33.csv"
<br>                 [10] "significantPermutationsM19.22.38.csv"

```
sigs<-c(2443,207,1285)
```
<br>
these are hardcoded numbers, the numbers of significant genes at pValue cutoff 0.1, 0.01, 0.0), before the permutations, in the original scenario with real cases vs controls <br>

```
for (file in files) {
                    sigs_temp <- read.table(file,row.names=1,header=F,sep=",",skip=1)
                    sigs<-cbind(sigs,sigs_temp)
                }
dim(sigs)
#              [1]    3 1001
```
<br>The following code is just an example of how to explore the numbers in sigs.  Each number represents the number of significant genes at either 0.1, 0.01 or 0.05 <br>

```
length(as.numeric(sigs["significant0_05",2:1001])[as.numeric(sigs["significant0_05",2:1001])>1285])
 #             [1] 1
length(as.numeric(sigs["significant0_01",2:1001])[as.numeric(sigs["significant0_01",2:1001])>207])
#              [1] 0
length(as.numeric(sigs["significant0_1",2:1001])[as.numeric(sigs["significant0_1",2:1001])>2443])
 #             [1] 1
summary(as.numeric(sigs["significant0_1",2:1001]))
#              Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#              0.00    1.00    3.00   19.05    8.00 3562.00 
summary(as.numeric(sigs["significant0_01",2:1001]))
 #             Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#              0.000   0.000   1.000   2.478   2.000 103.000 
summary(as.numeric(sigs["significant0_05",2:1001]))
 #             Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#              0.000    1.000    2.000    8.152    5.000 1821.000 
```
