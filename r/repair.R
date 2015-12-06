library(quantmod)
library(rjson)
source("conf/parameter.R")
source("r/mongoFunc.R")
source("r/restore.R")
source("r/calc.R")
source("r/update.R")

#args=c("20151127")
args = commandArgs(TRUE)
simpToday = args[1]
today = as.character(as.Date(args[1],"%Y%m%d"),"%Y-%m-%d")

idList=readLines("conf/etf.conf")
newRaw = updateRaw(idList, simpToday, simpToday, mongodb)
newRaw$Adjusted=0
newStrategy = updateStrategyData(mongodb,newRaw)
newStrategy$Adjusted = 0
latestDay = getLatestTradingDayBefore(mongodb,prodTable,simpToday)
latestDay$Adjusted = 0
getBuyInPoint(idList,newStrategy,latestDay)
getSellPoint()
