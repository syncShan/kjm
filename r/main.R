library(quantmod)
library(rmongodb)
setwd("dev/prod/")
source("conf/parameter.R")
source("r/mongoFunc.R")
source("r/restore.R")
source("r/calc.R")
source("r/update.R")

idList=readLines("conf/selectList.conf")
today="20151102"
newRaw = updateRaw(idList,today,today,mongodb)
newStrategy = updateStrategyData(mongodb,newRaw)


