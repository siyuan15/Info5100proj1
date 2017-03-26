#install.packages("reshape")
setwd("/Users/siyuan/Documents/Spring 2017/Info3300")

library(reshape)

aggData = read.csv(file = "RowTaxiAggregate.csv", header = T)
#rowData = melt(aggData, id = "Date")
#colnames(rowData)[colnames(rowData)=="variable"] <- "CompanyName"
#colnames(rowData)[colnames(rowData)=="value"] <- "PickupPerDay"
#levels(rowData$CompanyName)
#levels(rowData$CompanyName)[levels(rowData$CompanyName)=="Green.Taxis"] <- "Green Taxis"
#write.csv(rowData, file = "RowTaxiAggregate.csv")
#write.csv(aggData, file='RowTaxiAggregate.csv', quote = FALSE, row.names = FALSE)
#aggData = read.delim(file='RowTaxiAggregate.tsv')
#write.table(aggData, file='RowTaxiAggregate.tsv', quote=FALSE, sep='\t')
#test = read.delim("NYSEmployment.tsv")
#levels(test$Adjusted)

index = rep("1", length(aggData$Date))
aggData = cbind(index, aggData)

aggData2 = aggData
aggData2$index = rep("2", length(aggData$index))

final = rbind(aggData, aggData2)
levels(aggData$CompanyName)[levels(aggData$CompanyName)=="Green Taxis"] <- None

write.csv(final, file='finalTaxiAggregate.csv', quote = FALSE, row.names = FALSE)


aggPerHour = read.csv(file = "UberAggPerHour.csv", header = TRUE)

aggPerHour = aggPerHour[-c(169, 170, 171), ] 
write.csv(aggPerHour, file='UberAggPerHour.csv', quote = FALSE, row.names = FALSE)

