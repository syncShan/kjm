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


updateStrategyData = function(mongodb,newRaw,check){
  len = nrow(newRaw)
  res = data.frame()
  for(i in (1:len)){
    hisdf = getStockDFFromDB(mongodb,prodTable,newRaw[i,]$id)
    new = newRaw[i,]
    new[,addedSchema]=NA
    new[,"Adjusted"]=0
    hisdf[,"Adjusted"]=0
    #in here cannot make sure all the history data is enough
    hisdf = rbind(hisdf,new)
    strategyNew = getStrategySingleDay(hisdf,nrow(hisdf))
    if(!check){
      insertIntoDB(mongodb,prodTable,strategyNew)
    }
    res = rbind(res,strategyNew)
  }
  return(res)
}

repairStrategyData = function(mongodb,newRaw,check){
  len = nrow(newRaw)
  res = data.frame()
  for(i in (1:len)){
    hisdf = getStockDFFromDB(mongodb,rawTable,newRaw[i,]$id)
    new = newRaw[i,]
    hisdf[,addedSchema]=NA
    new[,addedSchema]=NA
    new[,"Adjusted"]=0
    hisdf[,"Adjusted"]=0
    #in here cannot make sure all the history data is enough
    hisdf = rbind(hisdf,new)
    strategyNew = getStrategySingleDay(hisdf,nrow(hisdf))
    if(!check){
      insertIntoDB(mongodb,prodTable,strategyNew)
    }
    res = rbind(res,strategyNew)
  }
  return(res)
}
