#!/bin/sh
ls -lAR | sort -rnk 5 | awk 'BEGIN{i=1} {if(i<6 && $1~"^-") {print i": " $5 , " " , $9 ; i++} if($1~"^d") {dir=dir+1} if($1~"^-") {file=file+1 ; size=size+$5} } END{print "Dir num: " dir "\nFile num: " file "\ntotal size : " size }' 
