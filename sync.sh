#!/bin/bash

MAQUINA="eris"

#ssh root@$MAQUINA "mkdir -p /media/songs/{principal,jingles,modao,universitario,romantico}"

#scp ansible/etc/nginx/sites-available/20-radio.somdomato.com root@$MAQUINA:/etc/nginx/sites-available/
#rsync -avzz /home/lucas/audio/sdm/ root@$MAQUINA:/media/songs/principal/ --delete --exclude="vinhetas"
#rsync -avzz /home/lucas/audio/sdm/vinhetas/ root@$MAQUINA:/media/songs/jingles/ --delete
rsync -avzz ansible/etc/liquidsoap/ root@$MAQUINA:/etc/liquidsoap/ --exclude="*old*"

ssh root@$MAQUINA "chown -R liquidsoap:liquidsoap /media/songs/ && systemctl restart icecast2-somdomato liquidsoap-somdomato"