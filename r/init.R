source("r/mongoFunc.R")
source("conf/parameter.R")
source("r/restore.R")
library(rjson)
library(quantmod)
date = as.character(as.Date(Sys.time()),"%Y%m%d")
#idList = readLines("conf/etf.conf")
idList = readLines("conf/etfInd.conf")
for( id in idList){
  stockdf = updateSingleStock(id,"20100101",date,mongodb,rawTable)
}
#restore key metrics from certain date for running
restoreAll(idList,"20110101",date,mongodb)

