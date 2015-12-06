source("r/mongoFunc.R")
source("conf/parameter.R")

date = as.character(as.Date(Sys.time()),"%Y%m%d")
fileName = paste("log/remind",date,".log",sep="")
df = getAllFromDB(mongodb, transactionTable)
if(nrow(df) > 0){
  op = getAllFromDB(mongodb,operationTable)
  if(nrow(op) >0){
    for( id in df$id){
      sub = op[op$id==id,]
      last = nrow(sub)
      if(last > 0 && sub[last,"operation"] == "sug sell"){
        sink(fileName,append = T)
        print(paste("remind to sell",id))
        print(sub[last,])
        sink()
      }
    }
  }
}
