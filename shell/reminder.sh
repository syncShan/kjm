#!/bin/bash
# should be setup at 9:20 everyday to remind selling stocks
R -f r/reminder.R
dd=`date +%Y%m%d`
if [ -s log/remind${dd}.log ]
then
    echo "reminder file find"
    python python/send_mail.py "log/remind${dd}.log" 
fi
