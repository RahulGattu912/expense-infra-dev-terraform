#!/bin/bash

dnf install ansible -y
# push
# ansible-playbook -i inventory mysql.yaml

# pull
ansible-pull -i localhost, -U https://github.com/RahulGattu912/expense-ansible-roles-tf.git main.yaml -e COMPONENT=backend -e ENVIRONMENT=$1
# this pulls main.yaml from the repo and applies it on that server 
# -e component=backend is the command line variable