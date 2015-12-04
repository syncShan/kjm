import urllib
import urllib2
import time
import datetime
import random
import sys 
import os
import json
import string
import smtplib
import redis
import time
from email.mime.text import MIMEText  


def send_mail(to_list, sub, content):  
    mail_host="smtp.163.com"
    mail_user="13774221411"
    mail_pass="lhfqwldeeeeteuem"
    mail_postfix="163.com"
    
    me = "sync" + "<" + mail_user + "@" + mail_postfix + ">"
    msg = MIMEText(content, _subtype='plain', _charset='gb2312')
    msg['Subject'] = sub
    msg['From'] = me
    msg['To'] = ";".join(to_list)
    try:
        server = smtplib.SMTP()
        server.connect(mail_host)
        server.login(mail_user,mail_pass)
        server.sendmail(me, to_list, msg.as_string())
        server.close()
        return True
    except Exception, e:
        print str(e).decode('utf-8')
        return False


if __name__ == '__main__':
    mailto_list=["13774221411@163.com"]
    dateStr = time.strftime("%Y%m%d") 
    s = 0.0
    content = ""
    f = open("log/"+dateStr+".log")
    for line in f:
        content += line+"\n"
    if s <= 10.0:
        mail_title = "prod:" + dateStr
        mail_body = content
    
        if send_mail(mailto_list, mail_title, mail_body):
            print "mail success!"
        else:
            print "mail failed!"

