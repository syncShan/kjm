#!/bin/bash
control=10
count=0
list=""

if [ ! -z $1 ]
then
    echo "date set to $1"
    date=$1
else
    date=`date +%Y%m%d`
fi

if [ ! -d ./rawdata/$date ]
then
    mkdir ./rawdata/$date
fi

if [ ! -d ./data/$date ]
then
    mkdir ./data/$date
fi

#clean the data before downloading 
rm ./rawdata/$date/data.csv
rm ./data/$date/data.csv

echo "starting on "$date
echo "**************"
while read line
do 
    let count=count+1
    if [ $line -ge 500000 ]
    then 
        select="sh"
    else
        select="sz"
    fi
    if [ $count -le $control ] 
    then
        list=$list",$select"$line
    else
        echo "downloading today data:$list"
        bash shell/get_single_today.sh $list $date 
	t=$(($RANDOM%10+1))
        sleep $t
        list="$select"$line
        count=0
    fi
done < conf/etf.conf
bash shell/get_single_today.sh $list $date 

echo "id,Open,Close,High,Low,Volume" > data/${date}/data.csv
awk '{if(length($0)>50) print $0}' rawdata/${date}/data.csv | awk -F',' '{print substr($1,12,8)","$2","$4","$5","$6","$9}' | sed 's/sh//g' | sed 's/sz//g' >> data/${date}/data.csv

R -f r/main.R --args $date
