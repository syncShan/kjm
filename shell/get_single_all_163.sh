#!/bin/bash
idList=$1
sdate=$2
edate=$3
url="http://quotes.money.163.com/service/chddata.html?code=$idList&start=$sdate&end=$edate&fields=TOPEN;TCLOSE;HIGH;LOW;VOTURNOVER"
res=`curl $url >> rawdata/$date/expdata.csv`
echo $res
