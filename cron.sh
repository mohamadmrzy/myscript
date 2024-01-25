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
