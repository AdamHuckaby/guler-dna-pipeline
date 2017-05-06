#
# Experimental script developed by Adam
# Requires output of another script in R environment. 
# Ask Adam for clarification here and develop a proper reproducible example.
#


#read and name data
data = SERBch1sighairpins59
colnames(data) = c("cName","start","end","type","deltaG","strand")

#This loop returns the indices in the data that are the first row of a contiguous region
row_list = c()
row_idx = 1
row_check_idx = row_idx
while(row_idx <= (nrow(data) -1 )) {

row_check = data[row_check_idx,"start"]
row = data[row_idx,"start"]
next_row = data[row_idx + 1,"start"]
if (next_row == row+1){
  row_idx = row_idx + 1
  #print(row_idx)
  } else { 
    row_list = append(row_list,which(data$start == row_check))
    row_check_idx = row_idx + 1
    row_idx = row_idx + 1
    
}
}
row_list = append(row_list,which(data$start == row_check))

#returns minima, a data frame with the minima for a each feature
minima = data.frame("cName","start","end","feature_name","deltaG","strand")
colnames(minima) = c("cName","start","end","feature_name","deltaG","strand")
minima = minima[-1,]

last_row = (nrow(data))
i = 1
while(i<length(row_list)){
  first = row_list[i]
  last = (row_list[i+1])-1
  sub = data[first:last,]
  sub$type = paste(data[first,"start"],"_",data[first,"cName"],sep = "")
  minimal_deltaG = min(sub[,"deltaG"])
  minima = rbind(minima, sub[which(sub$deltaG==minimal_deltaG),])
  
  i = i+1
}

first = row_list[length(row_list)]
last = nrow(data)
sub = data[first:last,]
sub$type = paste(data[first,"start"],"_",data[first,"cName"],sep = "")
minimal_deltaG = min(sub[,"deltaG"])
minima = rbind(minima, sub[which(sub$deltaG==minimal_deltaG),])
colnames(minima) = c("cName","start","end","feature_name","deltaG","strand")
 
#write the table 
write.table(minima,"SERBch1sighairpins59_Minima.txt", sep = "\t", quote=F, row.names = F)
