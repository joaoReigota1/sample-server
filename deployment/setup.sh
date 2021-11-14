#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo docker pull joaoreigota1/simple-server:latest
sudo docker run -p 4000:4000 joaoreigota1/simple-server:latest
