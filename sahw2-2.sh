#!/bin/sh


retry(){ 
ret=1
while [ $ret -eq 1 ]
do
curl --cookie-jar cookie1.txt  https://portal.nctu.edu.tw/captcha/pic.php

curl  -b cookie1.txt -O https://portal.nctu.edu.tw/captcha/pitctest/pic.php
mv pic.php pic.png
code=$(curl -F "image=@pic.png" https://nasa.cs.nctu.edu.tw/sap/2017/hw2/captcha-solver/api/)
judge=$(curl -b cookie1.txt  -d "username=${student_id}&password=${password}&seccode=${code}&pwdtype=static&Submit2=Login" https://portal.nctu.edu.tw/portal/chkpas.php? --cookie-jar cookie1.txt | awk '/LifeRay/{print 1}  /alert/{print 0}')
echo $judge
if [ $judge -eq 1 ] ; then
	ret=0
fi
echo $ret
done
}

student_id=$(dialog --title "student id" --inputbox "input your student id" 8 50 --output-fd 1)
password=$(dialog --title "password" --insecure --passwordbox "input your portal password" 8 50 --output-fd 1)

retry

HL=$(curl -b cookie1.txt --cookie-jar cookie1.txt https://portal.nctu.edu.tw/portal/relay.php?D=cos )
formdata=$(echo $HL | node extractFormdata.js)
curl  -d "$formdata" -b cookie1.txt --cookie-jar cookie1.txt https://course.nctu.edu.tw/index.asp 
clear
curl -b cookie1.txt https://course.nctu.edu.tw/adSchedule.asp | iconv  -f big5 -t utf-8 | awk '/<font COLOR/{ print $0 } /<br>/{print $1 }'| sed 's/<br>//g ; s///g'  | awk 'BEGIN{printf "Mon. Tue. Wed. Thu. Fri. Sat. Sun. \n" } {if(c < 112) { if(d<6) { if($0~"<font"){printf ". "} else {printf "%s " , $1;}  ;d++ } else { if($0~"<font"){printf ".\n "} else {printf "%s\n " , $1;}d=0 } c++}} ' | column -t 


