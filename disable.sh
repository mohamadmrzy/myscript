#!/bin/sh
echo "entry username number"
read username
usermod -L vpn-$username
