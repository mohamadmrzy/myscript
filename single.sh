#!/bin/bash

# Create /usr/local/bin/InoVPN-Single-User.sh file
echo '#!/bin/bash

# Set the maximum allowed concurrent connections
MAX_CONNECTIONS=1

# Get the currently logged-in user from PAM_USER environment variable
CURRENT_USER="$PAM_USER"

# Check if the current user is root
if [ "$CURRENT_USER" = "root" ]; then
  # Allow root user to have unlimited concurrent connections
  exit 0
fi

# Check if the current user is online using netstat and grep
LIVE_CONNECTIONS=$(sudo pgrep -a sshd | grep priv | grep -w "$CURRENT_USER" | wc -l)

# Compare the number of live connections with the maximum allowed connections
if [ "$LIVE_CONNECTIONS" -gt "$MAX_CONNECTIONS" ]; then
  # Deny access if the number of live connections exceeds the maximum allowed
  echo "Maximum concurrent connections reached. Access denied."
  exit 1
else
  # Allow access if the number of live connections is within the allowed limit
  exit 0
fi' | sudo tee /usr/local/bin/InoVPN-Single-User.sh

# Make the file executable
sudo chmod +x /usr/local/bin/InoVPN-Single-User.sh

# Add the following two lines at the end of sudo nano /etc/pam.d/sshd file
echo "account    required     pam_exec.so /usr/local/bin/InoVPN-Single-User.sh" | sudo tee -a /etc/pam.d/sshd
echo "auth       required     pam_exec.so /usr/local/bin/InoVPN-Single-User.sh" | sudo tee -a /etc/pam.d/sshd

# Uncomment TCP KeepAlive and set it to no in /etc/ssh/sshd_config
sudo sed -i 's/#TCPKeepAlive yes/TCPKeepAlive no/' /etc/ssh/sshd_config

# Uncomment ClientAliveInterval 0 and set it to 7 in /etc/ssh/sshd_config
sudo sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 7/' /etc/ssh/sshd_config

# Restart sshd service
sudo systemctl restart ssh
