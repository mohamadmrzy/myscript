#!/bin/bash
R='\033[0;31m'
G='\033[0;32m'
NOCOLOR='\033[0m'
IP=$(hostname -I | cut -d ' ' -f 1)
loc=$(curl -s ipinfo.io | jq -r '.country')
users=$(awk -F: '{ print $1}' /etc/passwd |grep "vpn-*")
for value in $users
do 
EXP=$(chage -l $value | awk -F: '/Account expires/{ print $2}')
if [[ $EXP =  *never ]]
then
    EXP_DAYS=9999
else
    NOW_SEC=$(date +%s)
    EXP_SEC=$(date -d "$EXP" +%s)
    EXP_DAYS=$((( EXP_SEC - NOW_SEC ) / 3600 / 24))
fi
if [ $EXP_DAYS -lt 12 ]
then
   echo  $value "Will expire in $EXP_DAYS days"
   echo "-----------------------------------------------" 

fi
done
echo "*************"
echo "this is daily report"
echo "server location:" $loc
echo "server IP:" $IP
echo "*************"
