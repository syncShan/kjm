library(rmongodb)
library(rjson)

getStockDFFromDB=function(mongodb,id){
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf,"id", id)
  query <- mongo.bson.from.buffer(buf)
  cur <- mongo.find(mongodb, adjTable, query = query)
  df = mongo.cursor.to.data.frame(cur)
  df$Date  = as.Date(df$Date,format= "%Y-%m-%d")
  df = subset(df,df$Volume>0)
  return(df)
}
