source("r/mongoFunc.R")
source("conf/parameter.R")
source("r/restore.R")
library(rjson)
library(quantmod)
date = as.character(as.Date(Sys.time()),"%Y%m%d")
idList = readLines("conf/etf.conf")
for( id in idList){
  stockdf = updateSingleStock(id,"20150101",date,mongodb,rawTable)
}

restoreAll(idList,"20150601",date,mongodb)

