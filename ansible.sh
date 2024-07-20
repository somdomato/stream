#!/bin/bash

if [ -f /etc/arch-release ]; then
  ansible-playbook -e "ansible_port=2200 ansible_python_interpreter=/usr/bin/python3" /home/lucas/code/somdomato/stream/ansible/playbook.yml -i eris.paxa.dev,
elif [ -f /etc/debian_version ]; then
  ansible-playbook -e "ansible_port=2200 ansible_python_interpreter=/usr/bin/python3" /home/lucas/code/somdomato/stream/ansible/playbook.yml -i eris.paxa.dev,
else
  ansible-playbook --connection=local -e "ansible_port=2200" /var/www/somdomato/ansible/playbook.yml -i localhost,
fi