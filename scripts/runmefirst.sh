#!/bin/bash

## Backup and copy j2 Docker-Compose template ##
mv /devops/awx/installer/roles/local_docker/templates/docker-compose.yml.j2 /devops/awx/installer/roles/local_docker/templates/docker-compose.yml.j2.bak
cp -ruv /devops/tools/awx/docker-compose.yml.j2 /devops/awx/installer/roles/local_docker/templates/

## Backup and copy inventory file ##
mv /devops/awx/installer/inventory /devops/awx/installer/inventory_backup
cp -ruv /devops/tools/awx/inventory /devops/awx/installer/

## Execute Ansible playbook ##
cd /devops/awx/installer
ansible-playbook -i inventory install.yml