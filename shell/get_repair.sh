#!/bin/bash
if [ ! -z $1 ]
then
    echo "date set to $1"
    date=$1
else
    echo "input targeting reparing date"
    exit 0
fi

rm ./rawdata/repair/*.csv
while read line
do 
    if [ $line -ge 500000 ]
    then 
        select="SS"
    else
        select="SZ"
    fi
    echo "downloading today data:$line"
    bash shell/get_single_repair.sh $line.$select 
done < conf/etf.cona
grep $date ./rawdata/repair/*.csv | sed 's/rawdata\/repair\///g' | sed 's/\.S.\.csv//g' | sed 's/:/,/g' | awk -F',' 'BEGIN{print "id,Open,Close,High,Low,Volume"}{print $1","$3","$6","$4","$5","$8}' > rawdata/repair/merge

R -f r/repair.R --args $date


