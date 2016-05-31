#!/bin/bash
idList=$1
date=$2
#url="http://hq.sinajs.cn/list=$idList"
url="http://112.90.6.246/list=$idList"
res=`curl $url >> rawdata/$date/data.csv`
echo $res
