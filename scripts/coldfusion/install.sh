#!/bin/sh

# Get things ready to install
sudo dnf -y install unzip httpd libxslt rsync
chmod +x ColdFusion_11_WWEJ_linux64.bin
chmod +x neo-security-config.sh
chmod +x httpd
chmod 664 coldfusion.service
chmod 664 cfjetty.service
sudo mv httpd /etc/rc.d/init.d/
sudo mv coldfusion.service /etc/systemd/system/
sudo mv cfjetty.service /etc/systemd/system/
sudo systemctl daemon-reload

# Disable Selinux
sudo setenforce 0
sudo bash -c 'echo SELINUX=disabled > /etc/selinux/config'
sudo bash -c 'echo SELINUXTYPE=targeted >> /etc/selinux/config'

# Install CF11
sudo ./ColdFusion_11_WWEJ_linux64.bin -f silent.properties
rm -f ColdFusion_11_WWEJ_linux64.bin
rm -f silent.properties

# Disable CF security
sudo ./neo-security-config.sh /opt/coldfusion/cfusion false

# Start CF server and wait a bit for it to be ready for connections
sudo /opt/coldfusion/cfusion/bin/coldfusion start; sleep 15

# Simulate a browser request on CFIDE to finish installation
wget --delete-after http://localhost:8500/CFIDE/administrator/index.cfm?configServer=true

# Stop CF server
sudo /opt/coldfusion/cfusion/bin/coldfusion stop

# Install ColdFusion add-ons
wget -q http://download.macromedia.com/pub/coldfusion/updates/11/addonservices/coldfusion_11_addon_linux64.bin
chmod +x coldfusion_11_addon_linux64.bin
sudo ./coldfusion_11_addon_linux64.bin -f installer.properties -i silent
rm -f coldfusion_11_addon_linux64.bin
rm -f installer.properties

# Enable CF security
sudo ./neo-security-config.sh /opt/coldfusion/cfusion true
rm -f neo-security-config.sh

# Config Apache to run in front of Tomcat
sudo /opt/coldfusion/cfusion/runtime/bin/wsconfig -ws Apache -dir /etc/httpd/conf -bin /usr/sbin/httpd -script /etc/init.d/httpd

# Set Apache to start on system boot
sudo systemctl enable httpd
sudo systemctl enable coldfusion
sudo systemctl enable cfjetty
