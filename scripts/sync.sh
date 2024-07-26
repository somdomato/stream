#!/bin/bash

MACHINE="eris"
SONGS_PATH="/media/songs"

rsync -avzz /home/lucas/audio/sdm/ root@$MACHINE:$SONGS_PATH/ --delete

ssh root@$MACHINE "chown -R liquidsoap:liquidsoap $SONGS_PATH && chown -R nginx:nginx $SONGS_PATH/uploads"
ssh root@$MACHINE "find $SONGS_PATH -type d -exec chmod 755 '{}' \; && find $SONGS_PATH -type f -exec chmod 644 '{}' \;"
ssh root@$MACHINE "systemctl restart icecast2-somdomato liquidsoap-somdomato"
