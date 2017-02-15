library(data.table) ##load library that uses bedtools
strt<-Sys.time() ##start the clock

setwd("/media/boom/BE00-0E14/Karolshuffle/SERB/")  ##set working directory
x <- 0  ##set increment to 0
Shuffle_Data <- data.frame(matrix(ncol = 2, nrow = 0))  ##create empty data frame
repeat {
  cmd1 <- "bedtools shuffle -i SERBcollapsed_SigMinima.bed -g SERB.genome -chrom -excl exclusion_SERBtotal.bed|bedtools sort -i stdin|bedtools closest -a SERBch6ATtracks.bed -b stdin -D a -t first" ##create the string command for bedtools to run/shuffle/calculate distance
  Shuffle_Closest <- fread(cmd1) ##use data.table package to read/use bedtools
  Average_Shuffle <- mean(abs(Shuffle_Closest$V13))
  SD_Shuffle <- sd(abs(Shuffle_Closest$V13))
  CurrentShuffleData <- cbind(Average_Shuffle, SD_Shuffle)
  Shuffle_Data <- rbind(Shuffle_Data, CurrentShuffleData)  ##add onto Shuffle_Data to create table with all values
  rm(Shuffle_Closest, Average_Shuffle, SD_Shuffle) ##remove extra variables
  x = x+1  #increment for repeat loop and set number of iterations
  if (x == 100){
    break
  }
} 

print(Sys.time()-strt) ##stop the time and print
write.table(Shuffle_Data,"SERBch6_shuffledx100.txt", sep = "\t", quote=F, row.names = F)
