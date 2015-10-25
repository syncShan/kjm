source("r/mongoFunc.R")
source("r/calc.R")
restoreSingle = function(id,startDate,endDate){
  df = getStockDFFromDB(mdb,"test.stock",id)
  res = toStrategyData(df,startDate,endDate)
  insertIntoDB(mdb,"prod.strategyOne",res)
}

ids = as.integer(readLines("conf/selectList.conf"))
for(id in ids){
  restoreSingle(id,"20140101","20150619")
}