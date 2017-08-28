#!/bin/bash
idList=$1
url="https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol="$idList"&apikey=UHLRH3IGO5KUQWII&datatype=csv"
res=`curl $url >> rawdata/repair/${idList}.csv`
echo $res
