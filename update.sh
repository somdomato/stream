#!/bin/bash

scp ansible/etc/icecast2/*.xml root@ananke:/etc/icecast2/
scp ansible/etc/liquidsoap/*.liq root@ananke:/etc/liquidsoap/
scp ansible/etc/systemd/system/liquidsoap.service root@ananke:/etc/systemd/system/
scp ansible/usr/local/bin/next-song root@ananke:/usr/local/bin/

ssh root@ananke "systemctl daemon-reload"
ssh root@ananke "systemctl restart liquidsoap"