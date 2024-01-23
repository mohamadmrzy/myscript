#!/bin/bash

#1- Updating The OS
sudo apt update -y && sudo apt upgrade -y

#2- Allow & Enable Firewall
sudo ufw allow 443
sudo ufw allow 7555
sudo ufw allow 72555
sudo ufw allow https
sudo ufw allow http
sudo ufw allow ssh
sudo ufw enable

# Write UsePAM yes at the end of /etc/ssh/sshd_config file
echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config

# Create user.sh file
echo "#!/bin/bash

# Create the users.txt file
echo \"Username:Password\" > users.txt

# Loop to create N users
for i in {1..30}; do
    # Generate a random 5-digit number password
    password=\$(shuf -i 101550-983621 -n 1)
    # Create the username in the format InoVPN-\$i
    username=\"vpn-\$i\"
    # Create the user with the generated username without creating a home directory
    sudo useradd -m \$username --shell=/bin/false
    # Set the password for the user using the chpasswd command
    echo \"\$username:\$password\" | sudo chpasswd
    # Append the created username and password to the users.txt file
    echo \"\$username:\$password\" >> users.txt
done

echo \"Users created successfully! The usernames and passwords are saved in users.txt file.\"" > user.sh

# Create logging_script.sh file
echo "#!/bin/bash

# Get the username from the PAM environment variable and remove the \"InoVPN-\" prefix
username=\"\$PAM_USER\"

# Check if the user has logged in for the first time (only for interactive sessions)
if [ \"\$PAM_TYPE\" == \"interactive\" ] && [ ! -f \"/home/\$username/.first_login\" ]; then
    # Log the first login event
    echo \"First login for user \$username at \$(date)\" >> /usr/local/bin/logfile.txt

    # Set the expiration date to 30 days from the first login
    exp_date=\$(date -d \"+30 days\" +%Y-%m-%d)
    sudo chage -E \"\$exp_date\" \"\$username\"

    # Create a marker file to indicate the first login
    touch \"/home/\$username/.first_login\"
    chown \$username:\$username \"/home/\$username/.first_login\"
fi

# Check if the user has logged in for the first time (also for non-interactive sessions)
if [ ! -f \"/home/\$username/.first_login\" ]; then
    # Log the first login event
    echo \"First login for user \$username at \$(date)\" >> /usr/local/bin/logfile.txt

    # Set the expiration date to 30 days from the first login
    exp_date=\$(date -d \"+30 days\" +%Y-%m-%d)
    sudo chage -E \"\$exp_date\" \"\$username\"

    # Create a marker file to indicate the first login
    touch \"/home/\$username/.first_login\"
    chown \$username:\$username \"/home/\$username/.first_login\"
fi

exit 0" > /usr/local/bin/logging_script.sh

# Make it executable
sudo chmod +x user.sh
sudo chmod +x /usr/local/bin/logging_script.sh

# Create users
./user.sh

# Write session optional pam_exec.so /usr/local/bin/logging_script.sh at the end of /etc/pam.d/sshd file
echo "session optional pam_exec.so /usr/local/bin/logging_script.sh" | sudo tee -a /etc/pam.d/sshd

#10- Solving Whatsapp Video call issue (daybreakersx)
#10.1
sudo apt install screen

#10.2
sudo apt install lsof

#10.3
sudo wget -O /usr/bin/badvpn-udpgw https://raw.githubusercontent.com/daybreakersx/premscript/master/badvpn-udpgw64

#10.4
sudo chmod +x /usr/bin/badvpn-udpgw

# Create /etc/rc.local file
echo "#!/bin/sh -e
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7555
exit 0" | sudo tee -a /etc/rc.local

# Make it executable
sudo chmod +x /etc/rc.local

# Restart sshd service
sudo systemctl restart ssh

# Reboot
sudo reboot
