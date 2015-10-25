library(rmongodb)
library(rjson)

mdb = mongo.create()

getStockDFFromDB=function(mongodb,table,id){
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf,"id", id)
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