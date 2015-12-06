source("r/mongoFunc.R")
source("conf/parameter.R")

date = as.character(as.Date(Sys.time()),"%Y%m%d")
df = getAllFromDB(mongodb, transactionTable)
