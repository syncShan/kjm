stocks = readLines("temp/sz")
stocks = readLines("temp/sh")
allStocks = list()
i = 1
while(i < length(stocks)){
  if(str_length(stocks[i])>100){
    print(paste("error on i=",i,sep=""))
    break;
  }
  id = as.integer(stocks[i])
  print(id)
  i = i + 1
  if(str_length(stocks[i])<100){
    print(paste("error on i=",i,sep=""))
    break;
  }
  allStocks[[as.character(id)]] = fromJSON(stocks[i])
  i= i + 1
}
RAR = sapply(allStocks,function(x){return(x$"RAR")})
RORSD = sapply(allStocks,function(x){return(x$"rorsd")})
sharp = sapply(allStocks,function(x){return(x$"sharp")})
MAR=sapply(allStocks, function(x){return(x$"mar")})
rsquare=sapply(allStocks, function(x){return(x$"rsquare")})
gainrate=sapply(allStocks, function(x){return(x$"gainRate")})
yearrate=sapply(allStocks, function(x){return(x$"yearRate")})
maxDecTime=as.integer(sapply(allStocks, function(x){return(x$"maxDeclineTime")}))
allMetrics = list(RAR,RORSD,sharp,MAR,rsquare,gainrate,yearrate,maxDecTime)
lapply(allMetrics,summary)

selected=c()
selectStock = list()
nameList = names(allStocks)
for(i in (1:length(allStocks))){
  cur = allStocks[[i]]
  if(cur$yearRate < 1.03) next
  if(cur$maxDeclineTime > 1100) next
  if(cur$RAR < 0) next
  if(cur$gainRate <0.2667) next
  if(cur$rorsd > 0.4395) next
  if(cur$sharp < 0) next
  if(cur$mar < 2.939) next
  if(cur$rsquare < 0.1277) next
  print(cur)
  selected=c(selected,nameList[i])
  selectStock[[nameList[i]]] = cur
}

selected=c()
selectStock = list()
nameList = names(allStocks)
for(i in (1:length(allStocks))){
  cur = allStocks[[i]]
  if(cur$yearRate < 1.03) next
  if(cur$maxDeclineTime > 1100) next
  if(cur$RAR < 0) next
  if(cur$gainRate <0.25) next
  if(cur$rorsd > 0.4236) next
  if(cur$sharp < 0) next
  if(cur$mar < 2.939) next
  if(cur$rsquare < 0.04) next
  print(cur)
  selected=c(selected,nameList[i])
  selectStock[[nameList[i]]] = cur
}