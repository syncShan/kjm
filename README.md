kjm

needed packages:rmongodb, rjson, quantmod, lubridate


db.stock.createIndex({id:1,Date:1},{ unique: true } )
use prod
db.strategyOne.createIndex({id:1,Date:1},{ unique: true } )

commands:
regular run: bash -x shell/get_all_today.sh 20151113
repair data: bash -x shell/get_repair.sh 2017-08-23

repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN"
