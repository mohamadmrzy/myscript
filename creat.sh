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


echo "#!/bin/bash


echo \"Username:Password\" > users.txt


for i in {1..30}; do
    password=\$(shuf -i 101550-983621 -n 1)
    username=\"vpn-\$i\"
    sudo useradd -m \$username --shell=/bin/false
    echo \"\$username:\$password\" | sudo chpasswd
    echo \"\$username:\$password\" >> users.txt
done

echo \"Users created successfully! The usernames and passwords are saved in users.txt file.\"" > user.sh


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
