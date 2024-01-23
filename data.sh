#!/bin/bash
users=$(awk -F: '{ print $1}' /etc/passwd |grep "vpn-*")
for value in $users
do 
EXP=$(chage -l $value | awk -F: '/Account expires/{ print $2}')

    echo  $value "Will expire in $EXP "
    echo "-----------------------------------------------" 

done
echo "*************"
echo "this is weekly report"
echo "server location: 🇨🇭"
echo "server IP: 179.43.155.81"
echo "*************"
