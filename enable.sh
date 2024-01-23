#!/bin/sh
echo "entry username number"
read username
usermod -U vpn-$username
