#reqire 
source("r/mongoFunc.R")
source("r/calc.R")
restoreSingle = function(id,startDate,endDate,mongodb){
  df = getStockDFFromDB(mongodb,rawTable,id)
  res = toStrategyData(df,startDate,endDate)
  insertIntoDB(mongodb,prodTable,res)
}

restoreAll = function(idList,startDate,endDate,mongodb){
  for(id in idList){
    restoreSingle(id,startDate,endDate,mongodb)
  }
}

#adjusted stock data
#id is 002508 like
adjustStock = function(id,startDate,endDate,mongodb){
  #removeStockData(id,mongodb,rawTable)
  removeStockData(id,mongodb,prodTable)
  #newRaw = updateSingleStock(id,"20000101",endDate,mongodb,tableName)
  restoreSingle(id,startDate,endDate,mongodb)
}

adjustAll = function(idList,startDate,endDate,mongodb){
  for(id in idList){
    adjustStock(id,startDate,endDate,mongodb)
  }
}