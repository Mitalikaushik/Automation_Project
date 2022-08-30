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

echo "checking the presence of inventory file"


inventoryfile=/var/www/html/inventory.html
if [ -f "$inventoryfile" ]; then
    echo "inventory.html file exists."
    #If the inventory file already exists,it will create new entry with the latest record in the metadata inventory file
    #As for each day/each run there will be 1 log tar file only
    ls -lhrt /tmp/*.tar | awk '{print $5"-" $9}' | awk -F  "-"  '{print $3"-"$4"\t"$5"-"$6"\t"$1}' | awk -F "." '{print $1"\t\t"$2"."$3}' | tail -1 >> /var/www/html/inventory.html
    echo "New record have been added"
else
    echo "inventory.html file does not exist."
    echo "Creating inventory file"
    touch $inventoryfile
    echo "Log Type"$'\t'"Date Created"$'\t'$'\t'"Type"$'\t'"Size". >> /var/www/html/inventory.html
    ls -lhrt /tmp/*.tar | awk '{print $5"-" $9}' | awk -F  "-"  '{print $3"-"$4"\t"$5"-"$6"\t"$1}' | awk -F "." '{print $1"\t\t"$2"."$3}' >> /var/www/html/inventory.html
    echo "New file created"
fi
cat /var/www/html/inventory.html

echo "Checking / Scheduling cron Job"
cronfile="/root/Automation_Project/automation.sh"
if grep -q $cronfile  /etc/cron.d/*; then
   echo "cron job is alreay scheduled"
else
   echo "cron Job is not scheduled"
   echo " Scheduling the cronjob for automation.sh"
   echo "05 00 * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
   echo "cron Job has been scheduled"
fi

cat /etc/cron.d/automation

