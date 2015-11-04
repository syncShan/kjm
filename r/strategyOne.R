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

getSummary = function(newStrategy){
  newStrategy$factor = (newStrategy$AvgLow - newStrategy$AvgHigh)/newStrategy$AvgHigh
  ord = order(newStrategy$factor,decreasing = TRUE)
  rank = newStrategy[ord,]
  rank = rank[rank$factor > 0,]
}

getBuyInPoint = function(id,mongodb){
  print(id)
  check = getStockDFFromDB(mongodb,prodTable,id)
  n = nrow(check)
  for(i in n:2){
    if(check[i,"AvgLow"]>check[i,"AvgHigh"] && check[i-1,"AvgLow"]<check[i-1,"AvgHigh"]){
      print(check[n,])
      print(check[i-1,])  
      print(check[i,])
      break;
    }
  }
}

checkPeriodInvest = function(idList,mongodb,startDate,endDate)
  examine = data.frame()
  for(id in idList){
    new = getStockDFFromDB(mongodb, prodTable, id)
    examine = rbind(examine,new)
  }
  examine = subset(examine,examine$Date > as.Date(startDate,"%Y%m%d") & examine$Date <= as.Date(endDate,"%Y%m%d"))
  examine$turn = ifelse(examine$AvgLow > examine$AvgHigh,1,0)
  changePoint = data.frame()
  for(i in 2: nrow(examine)){
    if(examine[i-1,"id"] == examine[i,"id"] &&  examine[i-1,"turn"] != examine[i,"turn"]){
      changePoint = rbind(changePoint,examine[i,])
    }
  }
  ord = order(changePoint$Date)
  changePoint = changePoint[ord,]
  #initialization
  moneyTotal = 200000
  moneyLeft = moneyTotal
  changePoint$operation=""
  changePoint$moneyLeft=0
  changePoint$share = 0
  changePoint$profit = 0
  stockInHand = data.frame()
  #for(i in 401: 450){
  for(i in 1: nrow(changePoint)){
    if(changePoint[i,"turn"] == 1){
      share = buyShare(moneyTotal,changePoint[i,"N"])
      if(moneyLeft > share*100*changePoint[i,"Close"]){
        moneyLeft = moneyLeft - share*100*changePoint[i,"Close"]
        changePoint[i,"operation"] = "buy"
        changePoint[i,"share"] = share
        changePoint[i,"moneyLeft"] = moneyLeft
        stockInHand = rbind(stockInHand,changePoint[i,])
        print("buy")
        print(changePoint[i,])
      }else{
        if(moneyLeft > 100*changePoint[i,"Close"]){
          share = as.integer(moneyLeft / (changePoint[i,"Close"]*100))
          moneyLeft = moneyLeft - share*100*changePoint[i,"Close"]
          changePoint[i,"operation"] = "poor buy"
          changePoint[i,"share"] = share
          changePoint[i,"moneyLeft"] = moneyLeft
          stockInHand = rbind(stockInHand,changePoint[i,])
          print("poor buy")
          print(changePoint[i,])
        }
        else{
          print("cannot buy")
          print(changePoint[i,])
        }
      }
    }else{
      id = changePoint[i,"id"]
      if(sum(stockInHand$id == id) == 0) next
      ind = which(stockInHand$id == id)
      moneyLeft = moneyLeft + stockInHand[ind,"share"] * changePoint[i,"Close"] * 100
      profit = stockInHand[ind,"share"] * 100 * (changePoint[i,"Close"] - stockInHand[ind,"Close"])
      changePoint[i,"operation"] = "sell"
      changePoint[i,"moneyLeft"] = moneyLeft
      changePoint[i,"profit"] = profit
      print("sell")
      print(changePoint[i,])
      stockInHand = stockInHand[stockInHand$id != id,]
    }
  }

  today = getStockDFFromDBByDate(mongodb,prodTable,"2015-10-30")
  marketValue = 0  
  
  for( i in 1:nrow(stockInHand)){
    id = stockInHand[i,"id"]
    if(sum(today$id == id) == 0){
      print("cannot get latest data for:")
      print(stockInHand[i,])
      next
    }
    singleValue = today[which(today$id == id),"Close"]*stockInHand[i,"share"]*100
    marketValue = marketValue + singleValue
  }
  