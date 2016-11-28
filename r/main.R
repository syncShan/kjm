library(quantmod)
library(rjson)
source("conf/parameter.R")
source("r/mongoFunc.R")
source("r/restore.R")
source("r/calc.R")
source("r/update.R")

#args=c("20151112")
args = commandArgs(TRUE)
print(args)
today = args[1]
check = F
if(length(args) == 2){
    check = (args[2] == 'Now')
}
CheckOpenDate = function(newRaw){
  len = nrow(newRaw)
  res = data.frame()
  for(i in 1:len){
    rec = newRaw[i,]
    id = rec$id
    check = getStockDFFromDB(mongodb, rawTable,id)
    if(nrow(check) == 0) next
    last = check[nrow(check),]
    if(rec$Open == last$Open && rec$Close == last$Close && rec$High == last$High){
      print(paste("the stock:",id, " seems not open today"))
      next
    }
    res = rbind(res,rec)
  }
  return(res)
}

idList=readLines("conf/etf.conf")
newRaw = read.csv(paste("data/",today,"/data.csv",sep=""))
newRaw$Date = as.Date(today,"%Y%m%d")
newRaw$Adjusted=0
fileName = paste("log/",today,".log",sep="")

sink(fileName)
newRaw = CheckOpenDate(newRaw)
sink()

if(nrow(newRaw) > 0 ){
  if(!check){
    insertIntoDB(mongodb,rawTable,newRaw)
  }
  newStrategy = updateStrategyData(mongodb,newRaw,check)
  sink(fileName, append = T)
  newStrategy$Adjusted = 0
  latestDay = getLatestTradingDayBefore(mongodb,prodTable,today)
  latestDay$Adjusted = 0
  getBuyInPoint(idList,newStrategy,latestDay)
  getSellPoint()
  sink()
}
