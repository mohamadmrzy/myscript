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

#!/bin/bash


echo '#!/bin/bash

MAX_CONNECTIONS=1

CURRENT_USER="$PAM_USER"

if [ "$CURRENT_USER" = "root" ]; then
  exit 0
fi

LIVE_CONNECTIONS=$(sudo pgrep -a sshd | grep priv | grep -w "$CURRENT_USER" | wc -l)

if [ "$LIVE_CONNECTIONS" -gt "$MAX_CONNECTIONS" ]; then
  echo "Maximum concurrent connections reached. Access denied."
  exit 1
else
  exit 0
fi' | sudo tee /usr/local/bin/mrzy-singel-user.sh


sudo chmod +x /usr/local/bin/mrzy-singel-user.sh


echo "account    required     pam_exec.so /usr/local/bin/mrzy-singel-user.sh" | sudo tee -a /etc/pam.d/sshd
echo "auth       required     pam_exec.so /usr/local/bin/mrzy-singel-user.sh" | sudo tee -a /etc/pam.d/sshd


sudo sed -i 's/#TCPKeepAlive yes/TCPKeepAlive no/' /etc/ssh/sshd_config


sudo sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 7/' /etc/ssh/sshd_config


sudo systemctl restart ssh

#!/bin/bash
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/alarm.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/changepass.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/data.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/datasend.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/disable.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/enable.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/exp.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/onlineuser.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/renew.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/sendalarm.sh
wget https://raw.githubusercontent.com/mohamadmrzy/myscript/main/status.sh

chmod +x alarm.sh changepass.sh data.sh datasend.sh disable.sh enable.sh exp.sh onlineuser.sh renew.sh sendalarm.sh status.sh

#!/bin/bash

# Define the cron commands
cron_command1="30 16 * * * /usr/bin/bash /root/sendalarm.sh"
cron_command2="32 16 */10 * * /usr/bin/bash /root/datasend.sh"

# Write the commands to a temporary file
echo -e "$cron_command1\n$cron_command2" > /tmp/cron_temp

# Add the commands to the crontab
crontab /tmp/cron_temp

# Remove the temporary file
rm /tmp/cron_temp

echo "Cron jobs added successfully."

reboot