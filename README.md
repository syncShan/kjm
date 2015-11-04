kjm

needed packages:rmongodb, rjson, quantmod, lubridate

db.strategyOne.createIndex({id:1,Date:1},{ unique: true } )
db.stock.createIndex({id:1,Date:1},{ unique: true } )