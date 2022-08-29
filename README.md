# Automation_Project
This is a bash script to automate management of apache2 service with below tasks:\
  it update the package details,whether the HTTP Apache server is already installed. If not present, then it installs the server.\
  checks whether the server is running or not. If it is not running, then it starts the server.\
  ensures that the server runs on restart/reboot, I.e., it checks whether the service is enabled or not. It enables the service if not enabled already.

After executing the script the tar file should be present in the correct format in the **/tmp/** directory.\
Tar gets copied to the S3 bucket with the user and timestamp details.

# To run script
Make the script executible\
chmod  +x  /root/Automation_Project/automation.sh\
#switch to root user with sudo su\
sudo  su\
./root/Automation_Project/automation.sh
