#!/bin/bash

sudo apt update -y && sudo apt upgrade -y

sudo ufw allow 443
sudo ufw allow 7555
sudo ufw allow 72555
sudo ufw allow https
sudo ufw allow http
sudo ufw allow ssh
sudo ufw enable

echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config


#!/bin/bash

usernames=("vpn-1" "vpn-2" "vpn-3" "vpn-4" "vpn-5" "vpn-6" "vpn-7" "vpn-8" "vpn-9" "vpn-10" "vpn-11" "vpn-12" "vpn-13" "vpn-14" "vpn-15" "vpn-16" "vpn-17" "vpn-18" "vpn-19" "vpn-20" "vpn-21" "vpn-22" "vpn-23" "vpn-24" "vpn-25" "vpn-26" "vpn-27" "vpn-28" "vpn-29" "vpn-30")
passwords=("856181" "789701" "768568" "910621" "720672" "839053" "258642" "975313" "643675" "911913" "163733" "228760" "114669" "187968" "619957" "659691" "732130" "129510" "709156" "390615" "712246" "925282" "259423" "728210" "774634" "937303" "110393" "858110" "107479" "467167")
output_file="users.txt"

# Create users and set passwords with chpasswd
for ((i=0; i<${#usernames[@]}; i++)); do
    username=${usernames[$i]}
    password=${passwords[$i]}

    # Create user if it doesn't exist
    if id "$username" &>/dev/null; then
        echo "User $username already exists. Skipping..."
    else
        useradd -m $username
        echo "$username:$password" | chpasswd
        echo "User $username created with password $password."
    fi
done

# Echo the list of usernames and passwords to a file
echo "List of Usernames and Passwords:" > "$output_file"
for ((i=0; i<${#usernames[@]}; i++)); do
    username=${usernames[$i]}
    password=${passwords[$i]}
    echo "$username:$password" >> "$output_file"
done

echo "Usernames and passwords have been saved to $output_file."



echo "#!/bin/bash

username=\"\$PAM_USER\"

if [ \"\$PAM_TYPE\" == \"interactive\" ] && [ ! -f \"/home/\$username/.first_login\" ]; then
    echo \"First login for user \$username at \$(date)\" >> /usr/local/bin/logfile.txt
    exp_date=\$(date -d \"+30 days\" +%Y-%m-%d)
    sudo chage -E \"\$exp_date\" \"\$username\"

    touch \"/home/\$username/.first_login\"
    chown \$username:\$username \"/home/\$username/.first_login\"
fi

if [ ! -f \"/home/\$username/.first_login\" ]; then
    echo \"First login for user \$username at \$(date)\" >> /usr/local/bin/logfile.txt

    exp_date=\$(date -d \"+30 days\" +%Y-%m-%d)
    sudo chage -E \"\$exp_date\" \"\$username\"

    touch \"/home/\$username/.first_login\"
    chown \$username:\$username \"/home/\$username/.first_login\"
fi

exit 0" > /usr/local/bin/logging_script.sh


sudo chmod +x user.sh
sudo chmod +x /usr/local/bin/logging_script.sh


./user.sh


echo "session optional pam_exec.so /usr/local/bin/logging_script.sh" | sudo tee -a /etc/pam.d/sshd


sudo apt install screen


sudo apt install lsof


sudo wget -O /usr/bin/badvpn-udpgw https://raw.githubusercontent.com/daybreakersx/premscript/master/badvpn-udpgw64


sudo chmod +x /usr/bin/badvpn-udpgw


echo "#!/bin/sh -e
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7555
exit 0" | sudo tee -a /etc/rc.local


sudo chmod +x /etc/rc.local


sudo systemctl restart ssh


sudo reboot
