#!/bin/bash

#ssh root@ananke "mkdir -p /media/songs/{principal,jingles,modao,universitario,romantico}"

#scp ansible/etc/nginx/sites-available/50-radio.somdomato.com root@ananke:/etc/nginx/sites-available/
#rsync -avzz /home/lucas/audio/sdm/ root@ananke:/media/songs/principal/ --delete --exclude="vinhetas"
#rsync -avzz /home/lucas/audio/sdm/vinhetas/ root@ananke:/media/songs/jingles/ --delete
rsync -avzz ansible/etc/liquidsoap/ root@ananke:/etc/liquidsoap/ --exclude="*old*" --delete

ssh root@ananke "chown -R liquidsoap:liquidsoap /media/songs/ && systemctl restart icecast2 liquidsoap"