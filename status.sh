#!/bin/bash
echo "entry username number"
read username
sudo chage --list vpn-$username
