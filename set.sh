#!/bin/bash

# Update and upgrade system
sudo apt update -y && sudo apt upgrade -y

# Configure UFW
sudo ufw allow 443
sudo ufw allow 2095
sudo ufw allow 7555
sudo ufw allow 72555
sudo ufw allow https
sudo ufw allow http
sudo ufw allow ssh
sudo ufw enable

# Enable PAM in SSH configuration
echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config
echo "Port 2095" | sudo tee -a /etc/ssh/sshd_config

# Create users and set passwords
usernames=("vpn-1" "vpn-2" "vpn-3" "vpn-4" "vpn-5" "vpn-6" "vpn-7" "vpn-8" "vpn-9" "vpn-10" "vpn-11" "vpn-12" "vpn-13" "vpn-14" "vpn-15" "vpn-16" "vpn-17" "vpn-18" "vpn-19" "vpn-20" "vpn-21" "vpn-22" "vpn-23" "vpn-24" "vpn-25" "vpn-26" "vpn-27" "vpn-28" "vpn-29" "vpn-30")
passwords=("856181" "789701" "768568" "920621" "720772" "839153" "259642" "974313" "623675" "991913" "163833" "573135" "119669" "189968" "699957" "699691" "792130" "199510" "799156" "399615" "712946" "925292" "259923" "728210" "774634" "937303" "110393" "858110" "107479" "467167")
output_file="users.txt"

for ((i=0; i<${#usernames[@]}; i++)); do
    username=${usernames[$i]}
    password=${passwords[$i]}

    if id "$username" &>/dev/null; then
        echo "User $username already exists. Skipping..."
    else
        useradd -m $username
        echo "$username:$password" | chpasswd
        echo "User $username created with password $password."
    fi
done

echo "List of Usernames and Passwords:" > "$output_file"
for ((i=0; i<${#usernames[@]}; i++)); do
    username=${usernames[$i]}
    password=${passwords[$i]}
    echo "$username:$password" >> "$output_file"
done

echo "Usernames and passwords have been saved to $output_file."

# Configure logging script for user login
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

sudo chmod +x /usr/local/bin/logging_script.sh

# Add logging script to SSH session
echo "session optional pam_exec.so /usr/local/bin/logging_script.sh" | sudo tee -a /etc/pam.d/sshd

# Install required packages
sudo apt install screen lsof

# Install and configure badvpn-udpgw
sudo wget -O /usr/bin/badvpn-udpgw https://raw.githubusercontent.com/daybreakersx/premscript/master/badvpn-udpgw64
sudo chmod +x /usr/bin/badvpn-udpgw

echo "#!/bin/sh -e
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7555
exit 0" | sudo tee -a /etc/rc.local

sudo chmod +x /etc/rc.local

sudo systemctl restart ssh

# Configure maximum concurrent connections
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

# Configure TCP and Client Alive settings in SSH
sudo sed -i 's/#TCPKeepAlive yes/TCPKeepAlive no/' /etc/ssh/sshd_config
sudo sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 7/' /etc/ssh/sshd_config

sudo systemctl restart ssh

# Download additional scripts
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

# Configure cron jobs
cron_command1="30 16 * * * /usr/bin/bash /root/sendalarm.sh"
cron_command2="32 16 */10 * * /usr/bin/bash /root/datasend.sh"

echo -e "$cron_command1\n$cron_command2" > /tmp/cron_temp

crontab /tmp/cron_temp

rm /tmp/cron_temp

echo "Cron jobs added successfully."

apt install jq -y

# Reboot the system
reboot
