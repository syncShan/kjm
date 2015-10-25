minHisDayCount = 80;
getStrategySingleDay = function(hisdf, i){
  hisdf = calTrueFluc(hisdf)
  len=nrow(hisdf)
  if(i < 51){
    return()
  }
  res = hisdf[i,]
  res$N = mean(hisdf[i-(19:0),"TrueFluc"])
  res$AvgHigh = mean(hisdf[i-(49:0),"High"])
  res$AvgLow = mean(hisdf[i-(4:0),"Low"])
  return(res)
}
