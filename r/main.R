library(quantmod)
library(rjson)
source("conf/parameter.R")
source("r/mongoFunc.R")
source("r/restore.R")
source("r/calc.R")
source("r/update.R")

#args=c("20151109")
args = commandArgs(TRUE)
today = args[1]

idList=readLines("conf/etf.conf")
newRaw = read.csv(paste("data/",today,"/data.csv",sep=""))
newRaw$Date = as.Date(today,"%Y%m%d")
newRaw$Adjusted=0
#newRaw = updateRaw(idList,today,today,mongodb)
insertIntoDB(mongodb,rawTable,newRaw)
newStrategy = updateStrategyData(mongodb,newRaw)
newStrategy$Adjusted = 0
lastestDay = getLatestTradingDayBefore(mongodb,prodTable,today)
lastestDay$Adjusted = 0
getBuyInPoint(idList,newStrategy,lastestDay)
getSellPoint()
