idList = readLines("conf/etfInd.conf")
for(id in idList){
  fileName = paste("data/etfind/",id,".TXT",sep="")
  df = read.table(fileName,col.names = c('Date','Open','High','Low','Close','Volume','Quan'),header = T)
  df$Date = as.Date(df$Date,"%Y-%m-%d")
  stockData = df[,1:6]
  stockData$id = as.integer(id)
  for( i in seq(1,nrow(stockData))){
    if(stockData[i,"Volume"] == 0 ) next
    json = toJSON(stockData[i,])
    bson = mongo.bson.from.JSON(json)
    if(!mongo.insert(mongodb,"test.stock",bson)){
      print(paste("failed to insert:",json))
    }
  }
}

startDate = "20140101"
endDate = "20161201"
restoreAll(idList, "20140101","20161201",mongodb)
