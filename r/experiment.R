source("conf/parameter.R")
source("r/calc.R")
source("r/strategyThree.R")

for(id in idList){
  df = getStockDFFromDB(mongodb,rawTable,id)
  strategyDf = toStrategyData(df,"20100101","20151111")  
  insertIntoDB(mongodb,expTable,strategyDf)
}

startDate = "20120101"
endDate = "20130101"
checkPeriodInvest(idList,mongodb,startDate,endDate)

startDate = "20130101"
endDate = "20140101"
checkPeriodInvest(idList,mongodb,startDate,endDate)

startDate = "20140101"
endDate = "20141231"
checkPeriodInvest(idList,mongodb,startDate,endDate)

startDate = "20150101"
endDate = "20151231"
checkPeriodInvest(idList,mongodb,startDate,endDate)

startDate = "20160101"
endDate = "20161101"
checkPeriodInvest(idList,mongodb,startDate,endDate)
