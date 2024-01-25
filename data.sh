#!/bin/bash
IP=$(hostname -I | cut -d ' ' -f 1)
loc=$(curl -s ipinfo.io | jq -r '.country')
users=$(awk -F: '{ print $1}' /etc/passwd |grep "vpn-*")
for value in $users
do 
EXP=$(chage -l $value | awk -F: '/Account expires/{ print $2}')

    echo  $value "Will expire in $EXP "
    echo "-----------------------------------------------" 

done
echo "*************"
echo "this is weekly report"
echo "server location:" $loc
echo "server IP:" $IP
echo "*************"
