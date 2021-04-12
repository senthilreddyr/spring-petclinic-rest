#!/bin/bash
sudo apt -y update && sudo apt-get -y upgrade
sudo apt -y install software-properties-common
sudo apt -y install openjdk-8-jre openjdk-8-jdk
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql-client
