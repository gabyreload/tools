#!/bin/bash

## clone awx repo in Github
cd /config
git clone https://github.com/ansible/awx.git --branch 16.0.0

## Backup and copy j2 Docker-Compose template ##
mv /config/awx/installer/roles/local_docker/templates/docker-compose.yml.j2 /config/awx/installer/roles/local_docker/templates/docker-compose.yml.j2.bak
cp -ruv /config/tools/awx/docker-compose.yml.j2 /config/awx/installer/roles/local_docker/templates/

## Backup and copy inventory file ##
mv /config/awx/installer/inventory /config/awx/installer/inventory_backup
cp -ruv /config/tools/awx/inventory /config/awx/installer/

## Execute Ansible playbook ##
cd /config/awx/installer
/usr/bin/ansible-playbook -i inventory install.yml
