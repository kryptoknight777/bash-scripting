#!/bin/bash
# Deploy LAMP Stack using dnf on Linux Red Hat

echo -e "\n\nUpdating all packages and upgrading latest patches\n"
sudo dnf upgrade -y

echo -e "\n\nInstalling Apache Web Server\n"
sudo dnf install httpd -y

echo -e "\n\nStarting & Enabling Apache Web Server for automatic startup\n"
sudo systemctl enable --now httpd

echo -e "\n\nInstalling MariaDB Server\n"
sudo dnf install mariadb-server -y

echo -e "\n\nStarting and Enabling MariaDB Server for automatic startup\n"
sudo systemctl enable --now mariadb
sudo mysqlshow

echo -e "\n\nInstalling PHP\n"
sudo dnf install -y php php-mysqlnd

echo -e "\n\nRestarting Apache Server due to PHP install\n"
sudo systemctl restart httpd

echo -e "\n\nLAMP Installation Completed"


exit 0