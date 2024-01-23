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
