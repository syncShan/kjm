library(quantmod)
library(rjson)
source("conf/parameter.R")
source("r/mongoFunc.R")
source("r/restore.R")
source("r/calc.R")
source("r/update.R")

#args=c("2015-11-12")
args = commandArgs(TRUE)
print(args)
today = as.character(as.Date(args[1],"%Y-%m-%d"),format="%Y%m%d")

idList=readLines("conf/etf.conf")
newRaw = read.csv(paste("rawdata/repair/merge",sep=""))
newRaw$Date = as.Date(today,"%Y%m%d")
newRaw$Adjusted=0

check=F
if(nrow(newRaw) > 0 ){
  if(!check){
    insertIntoDB(mongodb,rawTable,newRaw)
  }
  newStrategy = updateStrategyData(mongodb,newRaw,check)
  newStrategy$Adjusted = 0
  latestDay = getLatestTradingDayBefore(mongodb,prodTable,today)
  latestDay$Adjusted = 0
  getBuyInPoint(idList,newStrategy,latestDay)
  getSellPoint()
}
