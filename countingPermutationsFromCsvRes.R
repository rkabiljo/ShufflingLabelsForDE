
files <- list.files(pattern = "\\.csv$")
files
#             [1] "significantPermutationsB19.40.57.csv"
#            [2] "significantPermutationsC19.28.36.csv"
#              [3] "significantPermutationsD20.02.40.csv"
#              [4] "significantPermutationsE20.02.39.csv"
#              [5] "significantPermutationsF20.06.08.csv"
#              [6] "significantPermutationsG20.05.04.csv"
#              [7] "significantPermutationsH20.04.42.csv"
#              [8] "significantPermutationsK19.29.54.csv"
#              [9] "significantPermutationsL19.55.33.csv"
#              [10] "significantPermutationsM19.22.38.csv"
sigs<-c(2443,207,1285)
for (file in files) {
                    sigs_temp <- read.table(file,row.names=1,header=F,sep=",",skip=1)
                    sigs<-cbind(sigs,sigs_temp)
                }
dim(sigs)
#              [1]    3 1001
sigs[,1:5]
 #             sigs V2 V3 V4 V5
#              significant0_1  2443  3 15  1  2
#              significant0_01  207  2  5  1  0
#              significant0_05 1285  2 11  1  2
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