#!/bin/sh
terraform apply
ansible-playbook -u `terraform output admin_username` -i `terraform output host`, --private-key ~/.ssh/id_rsa ansible-playbook.yml