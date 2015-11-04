#require
#source("r/mongoFunc.R")
updateRaw = function(idList,startDate,endDate,mongodb){
  allStock = data.frame()
  for(id in idList){
    print(paste("updating on ",id,sep=""))
    single = try(updateSingleStock(id,startDate,endDate,mongodb,rawTable))
    allStock = rbind(allStock,single)
  }
  return(allStock)
}


updateStrategyData = function(mongodb,newRaw){
  #for( col in colnames(newRaw)){
  #  if(col=="Date") next
  #  newRaw[,col] = as.numeric(newRaw[,col])
  #}
  len = nrow(newRaw)
  res = data.frame()
  for(i in (1:len)){
    hisdf = getStockDFFromDB(mongodb,prodTable,newRaw[i,]$id)
    new = newRaw[i,]
    new[,addedSchema]=NA
    new=new[,-6]
    #in here cannot make sure all the history data is enough
    hisdf = rbind(hisdf,new)
    strategyNew = getStrategySingleDay(hisdf,nrow(hisdf))
    insertIntoDB(mongodb,prodTable,strategyNew)
    res = rbind(res,strategyNew)
  }
  return(res)
}