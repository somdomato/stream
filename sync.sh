#!/bin/bash

ssh root@ananke "mkdir -p /media/{songs,jingles}"

rsync -avzz /home/lucas/audio/sdm/ root@ananke:/media/songs/ --delete --exclude="vinhetas"
rsync -avzz /home/lucas/audio/sdm/vinhetas/ root@ananke:/media/jingles/ --delete

ssh root@ananke "chown -R liquidsoap:liquidsoap /media/songs/ /media/jingles/"