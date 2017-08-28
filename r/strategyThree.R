minHisDayCount = 25;
getStrategySingleDay = function(hisdf, i){
  hisdf = calTrueFluc(hisdf)
  len=nrow(hisdf)
  if(i < minHisDayCount){
    return()
  }
  res = hisdf[i,]
  res$N = mean(hisdf[i-(19:0),"TrueFluc"])
  res$AvgHigh = mean(hisdf[i-(24:0),"High"])
  res$AvgLow = mean(hisdf[i-(4:0),"Low"])
  return(res)
}

getBuyInPoint = function(idList,newStrategy,lastestDay){
  df = rbind(lastestDay,newStrategy)
  ids = as.integer(idList)
  for(id in ids){
    sub = df[df$id==id,]
    
    if(nrow(sub)<2){
      print(paste("not enough data for id:",id,sep=""))
      print(sub)
    }
    sub$turn = sub$AvgLow > sub$AvgHigh
    if(sub[2,]$turn && !sub[1,]$turn){
      sub$share = buyShare(money, sub$N)
      print(paste("trend found please buy in id:",id," with target share:",sub[2,]$share),sep="")
      sub$operation=""
      sub[1,]$operation = "pre day"
      sub[2,]$operation = "sug buy"
      print(sub)
      insertIntoDB(mongodb,operationTable,sub)
    }
    if(!sub[2,]$turn && sub[1,]$turn){
      print(paste("trend end please sell id:",id," with target share:",sub[2,]$share),sep="")
      sub$operation=""
      sub[1,]$operation = "pre day"
      sub[2,]$operation = "sug sell"
      print(sub)
      insertIntoDB(mongodb,operationTable,sub)
    }
    print(sub)
  }
}

getSellPoint = function(){
  df  = getStockDFFromDB(mongodb,transactionTable,NULL)
  ids = df$id
  for(id in ids){
    single = tail(getStockDFFromDB(mongodb,prodTable,id),24)
    last = tail(single,4)
    val1 = sum(single$High)
    val2 = sum(last$Low)
    approximateThreshold = single[24,]$AvgHigh * 5 - val2
    accurateThreshold = val1 - 4*val2
    print(paste(id,":approximate sell point: if LOW < ",approximateThreshold," then sell out",sep=""))
    print(paste(id,":accurate sell point: if 10*LOW - HIGH  < ",accurateThreshold," then sell out",sep=""))
  }
}


singleAnalysis = function(id,mongodb,startDate,endDate){
  examine = getStockDFFromDB(mongodb, prodTable, id)
  historyAnalysis(examine,startDate,endDate)
}

checkPeriodInvest = function(idList,mongodb,startDate,endDate){
  examine = data.frame()
  for(id in idList){
    new = getStockDFFromDB(mongodb, expTable, id)
    new$Adjusted = 0
    examine = rbind(examine,new)
  }
  historyAnalysis(examine,startDate,endDate)
}

historyAnalysis = function(df,startDate,endDate){
  examine = df
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
  today = getStockDFFromDBByDate(mongodb,prodTable,as.character(as.Date(endDate,"%Y%m%d")-1,"%Y-%m-%d"))
  #today = getStockDFFromDBByDate(mongodb,prodTable,endDate)
  marketValue = 0  
  if(nrow(stockInHand) == 0){
    print("do not got stock in hand")
    return()
  }
  print("stockInHand:")
  print(stockInHand)
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
  print(marketValue+moneyLeft)
}

getPlot = function(df){
  plot(df$Date,df$Close,type="l")
  points(df$Date,df$AvgHigh,col="red",pch=4)
  points(df$Date,df$AvgLow,col="blue",pch=20)
}
