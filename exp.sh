#!/bin/sh
echo "entry username number"
read username
echo "entry date"
read date
sudo chage --expiredate $date vpn-$username
