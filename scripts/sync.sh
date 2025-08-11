#!/usr/bin/env bash

MACHINE="tyche"
REMOTE_SONGS_PATH="/var/music"
[ "$(uname -s)" == "Darwin" ] && \
    LOCAL_SONGS_PATH="/Users/lucas/Music/sdm" || \
    LOCAL_SONGS_PATH="/home/lucas/music/sdm"
DELETE=""
ssh root@$MACHINE "mkdir -p $REMOTE_SONGS_PATH"
rsync -avzz $LOCAL_SONGS_PATH/ root@$MACHINE:$REMOTE_SONGS_PATH/ $DELETE
ssh root@$MACHINE "chown -R liquidsoap:liquidsoap $REMOTE_SONGS_PATH"
ssh root@$MACHINE "find $REMOTE_SONGS_PATH -type d -exec chmod 755 '{}' \;"
ssh root@$MACHINE "find $REMOTE_SONGS_PATH -type f -exec chmod 644 '{}' \;"
ssh root@$MACHINE "systemctl restart icecast2-somdomato liquidsoap-somdomato"
