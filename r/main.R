library(quantmod)
library(rjson)
source("conf/parameter.R")
source("r/mongoFunc.R")
source("r/restore.R")
source("r/calc.R")
source("r/update.R")

#args=c("20151112")
args = commandArgs(TRUE)
today = args[1]

idList=readLines("conf/etf.conf")
newRaw = read.csv(paste("data/",today,"/data.csv",sep=""))
newRaw$Date = as.Date(today,"%Y%m%d")
newRaw$Adjusted=0
insertIntoDB(mongodb,rawTable,newRaw)
newStrategy = updateStrategyData(mongodb,newRaw)
sink(paste("log/",today,".log",sep=""))
newStrategy$Adjusted = 0
latestDay = getLatestTradingDayBefore(mongodb,prodTable,today)
latestDay$Adjusted = 0
getBuyInPoint(idList,newStrategy,latestDay)
getSellPoint()
sind()
