#!/bin/bash

if [ -f /etc/arch-release ]; then
  ansible-playbook -e "ansible_port=2200 ansible_python_interpreter=/usr/bin/python3" /home/lucas/code/somdomato/stream/ansible/playbook.yml -i eris.paxa.dev,
else
  ansible-playbook --connection=local -e "ansible_port=2200" /home/nginx/radio.somdomato.com/ansible/playbook.yml -i localhost,
fi