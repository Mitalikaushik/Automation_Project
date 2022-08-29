#!/bin/bash
echo "package update"
sudo apt update -y
echo "update done"
echo "checking if apache2 is installed"
pkgs='apache2'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  echo "installing apache2"
  sudo apt-get install $pkgs -y
else
  echo "apache2 is already installed"
fi
echo "Checking if apache2 is running"
servstat=$(service apache2 status)

if [[ $servstat == *"active (running)"* ]]; then
  echo "apache2 server is running"
else echo "starting the apache2 server"
     systemctl start apache2.service
fi
echo "Checking if apache2 is enabled"
if [[ $servstat == *" enabled;"* ]]; then
  echo "apache2 server is enabled"
else echo "enabling the apache2 server to restart"
     systemctl enable apache2.service
fi
echo "creating tar of apache logs"
timestamp=$(date '+%d%m%Y-%H%M%S')
myname="Mitali"
tar -czvf ${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
echo "tar created successfully"
echo "copying tar file into temp"
cp ${myname}-httpd-logs-${timestamp}.tar /tmp/
echo "copy done"
echo "aws cli -copy the archive to s3 bucket"
s3_bucket=upgrad-mitali
aws s3 ls
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
