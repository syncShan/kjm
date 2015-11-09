#!/bin/bash
idList=$1
date=$2
url="http://hq.sinajs.cn/list=$idList"
res=`curl $url >> rawdata/$date/data.csv`
echo $res
