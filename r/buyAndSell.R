library(rjson)
source("conf/parameter.R")
source("r/mongoFunc.R")

args = commandArgs(TRUE)
print(args)
#args = c(510050,2.45,39000,"2015-11-06","buy")
id = as.integer(args[1])
price = as.numeric(args[2])
share = as.integer(args[3])
Date = args[4]
operation=args[5]


if(operation == "buy"){
  df = data.frame(id,price,share,Date)
  insertIntoDB(mongodb,transactionTable,df)
  optDf = data.frame(id,price,share,Date,operation)
  insertIntoDB(mongodb,operationTable,optDf)
}else{
  stock = getStockDFFromDB(mongodb,transactionTable,id)
  optDf = data.frame(id,price,share,Date,operation,stock)
  removeStockData(id,mongodb,transactionTable)
  insertIntoDB(mongodb,operationTable,optDf)
}
