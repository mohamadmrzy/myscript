#!/bin/sh
echo "entry username number"
read username
exp_date=$(date -d "+30 days" +%Y-%m-%d)
sudo chage -E $exp_date vpn-$username
