#!/bin/bash
sudo mv /home/ubuntu/devops-task.service /etc/systemd/system/ && sudo chown root:root /etc/systemd/system/devops-task.service && sudo chmod 744 /etc/systemd/system/devops-task.service
sudo apt-get update
sudo apt-get install python3-pip awscli  python-urllib3 -y
pip3 install flask waitress boto3
sudo systemctl daemon-reload
sudo systemctl enable devops-task.service
sudo systemctl start devops-task.service
echo "instalation done"
