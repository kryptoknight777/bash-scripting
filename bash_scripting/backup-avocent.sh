#!/bin/bash
#This script is designed to find any backup files in /mnt/hdUser/backup greater than 30 days and delete from storage.
#Afterwards, a "saveconf" command is executed to backup current config and save to the /mnt/hdUser/backup directory.
#Then, the latest backup file is transferred to a remote server via SSH passwordless authentication.
#Last, another SSH connection is established to verify the file exists in the remote server.
#Created by kryptoknight777 1-29-2024

path="/mnt/hdUser/backup/*"
days=30
filename="FQDN-of-Avocent_$(date +%F)"
source="/mnt/hdUser/backup/FQDN-of-Avocent_$(date +%F)"
destination="user@ipv4-address:/path/to/file"
logfile="/home/root/log/$(date +%F).txt"
destfilename="/path/to/file/FQDN-of-Avocent_$(date +%F)"
sshdest="user@ipv4-address"

find $path -mtime +$days -exec rm {} \;
echo ""

if [ $? -eq 0 ]
then
  echo "$(date) Successfully found backup config files in /mnt/hdUser/backup directory. Any files greater than 30 days were deleted." | tee -a $logfile
else
  echo "$(date) Command to find files and remove greater than 30 days has failed." | tee -a $logfile
fi

echo ""
saveconf --local $filename
echo ""

if [ $? -eq 0 ]
then
  echo "$(date) Successfully saved new backup config file in /mnt/hdUser/backup directory." | tee -a $logfile
else
  echo "$(date) Command to save new backup config file has failed." | tee -a $logfile
fi

echo ""
scp $source $destination
echo ""
if [ $? -ne 0 ]
then
  echo "$(date) Command to transfer file to remote server has failed" | tee -a $logfile
exit 1
fi

echo ""
ssh $sshdest [[ -f $destfilename ]] && echo "$(date) Successfully transferred backup file to remote server." | tee -a $logfile || echo "$(date) Confirmed that file did not transfer to remote server, Please troubleshoot error!" | tee -a $logfile

exit 0
