#require
#library(rmongodb)
#library(rjson)

mongodb = mongo.create()

getStockDFFromDB=function(mongodb,table,id){
  id = as.integer(id)
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf,"id", id)
  query <- mongo.bson.from.buffer(buf)
  cur <- mongo.find(mongodb, table, query = query)
  df = mongo.cursor.to.data.frame(cur)
  df$Date  = as.Date(df$Date,format= "%Y-%m-%d")
  df = subset(df,df$Volume>0)
  return(df)
}

getStockDFFromDBByDate=function(mongodb,table,date){
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf,"Date", date)
  query <- mongo.bson.from.buffer(buf)
  cur <- mongo.find(mongodb, table, query = query)
  df = mongo.cursor.to.data.frame(cur)
  df$Date  = as.Date(df$Date,format= "%Y-%m-%d")
  df = subset(df,df$Volume>0)
  return(df)
}

insertIntoDB = function(mongodb,table,df){
  if(!mongo.is.connected(mongodb)){
    print("mongo connection is already closed!")
    return()
  }
  df$Date = as.character(df$Date)
  count = 0
  for( i in seq(1,nrow(df))){
    json = toJSON(df[i,])
    bson = mongo.bson.from.JSON(json)
    if(!mongo.insert(mongodb,table,bson)){
      print(paste("failed to insert:",json))
    }
    else{
      count = count+1
    }
  }
  print(paste(count,"/",nrow(df)," rows inserted",sep=""))
}

#market =SH SZ
#id could be interger or string
updateSingleStock = function(id,startDate,endDate,mongodb,tableName){
  if(!mongo.is.connected(mongodb)){
    print("mongo connection is already closed!")
    return()
  }
  if(as.integer(id) >=600000){
    market = "SS"
  }else{
    market = "SZ"
  }
  sid = paste(as.character(id),".",market,sep="")
  cat(paste("getting...",sid,sep=" "))
  sDate = as.Date(startDate,"%Y%m%d")
  eDate = as.Date(endDate,"%Y%m%d")
  input = try(getSymbols(sid,from = sDate,to=eDate,auto.assign = FALSE))
  if(is.null(nrow(input)) ) return()
  adjusted = adjustOHLC(input,symbol.name = sid)
  if(is.null(ncol(adjusted)) || ncol(adjusted) == 0){
    print(paste("[ERROR] cannot find data for id:",id,sep=""))
    return()
  }
  stockData = data.frame(adjusted)
  colnames(stockData) = yahooSchema
  stockData$Date = rownames(stockData)
  stockData$id = as.integer(id)
  stockData = stockData[stockData$Volume > 0,]
  if(nrow(stockData) == 0){
    print(paste("[ERROR] cannot find data for id:",id,sep=""))
    return()
  }else{
    #data entry check
    days = as.Date(stockData[nrow(stockData),"Date"],"%Y-%m-%d") - as.Date(stockData[1,"Date"],"%Y-%m-%d")
    if(nrow(stockData) < days*2/3){
      print(paste("[WARNING] id:",id," seems don't have enough data:",nrow(stockData),". Please check!",sep=""))
    }else{
      cat(paste(nrow(stockData)," inserted!\n"))
    }
  }
  for( i in seq(1,nrow(stockData))){
    if(stockData[i,"Volume"] == 0 ) next
    json = toJSON(stockData[i,])
    bson = mongo.bson.from.JSON(json)
    if(!mongo.insert(mongodb,tableName,bson)){
      print(paste("failed to insert:",json))
    }
  }
  return(stockData)
}

removeStockData = function(id,mongodb,tableName){
  id = as.integer(id)
  if(!mongo.is.connected(mongodb)){
    print("mongo connection is already closed!")
    return()
  }
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf,"id", id)
  criteria <- mongo.bson.from.buffer(buf)
  mongo.remove(mongodb,tableName,criteria)
}