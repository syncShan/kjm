
#PDC is yesterday close
trueFluc = function(H,L,PDC){
  return(max(max(H-L,H-PDC),PDC-L))
}

calTrueFluc= function(df){
  len = nrow(df)
  for(i in 1:len){
    df[i,"TrueFluc"] <- trueFluc(H=df[i,"High"],L=df[i,"Low"],PDC = df[i-1,"Close"] )
  }
  return(df)
}

source("r/strategyOne.R")

#startDate is string like "20150101"
toStrategyData = function(df,startDate,endDate){
  sDate = as.Date(startDate,"%Y%m%d")
  eDate = as.Date(endDate,"%Y%m%d")
  sub = subset(df,df$Date >= sDate  - minHisDayCount & df$Date <= eDate)
  i = which(sub$Date >sDate)[1]
  len = nrow(sub)
  res = data.frame()
  while(i <= len){
    res = rbind(res,getStrategySingleDay(sub,i))
    i = i+1
  }
  return(res)
}



