library(quantmod)
library(rmongodb)
setwd("dev/prod/")
source("conf/parameter.R")
source("r/mongoFunc.R")

idList=readLines("conf/selectList.conf")
today="20150623"
mongodb = mongo.create()
updateRaw(idList,today,today,mongodb,rawTable)
