#!/bin/bash

# https://superuser.com/a/584177/448225
# ffmpeg (or more likely the fork avconv if you're using Debian or Ubuntu - these instructions should apply equally to both, 
# though nobody knows how far apart they may drift in the future) should be in the repositories of your distro.
ffmpeg -i input.mp3 -c:a libvorbis -q:a 4 output.ogg

# To do a whole directory full of MP3s:
for f in ./*.mp3; do ffmpeg -i "$f" -c:a libvorbis -q:a 4 "${f/%mp3/ogg}"; done

# Recursively, with find:

find . -type f -name '*.mp3' -exec bash -c 'ffmpeg -i "$0" -c:a libvorbis -q:a 4 "${0/%mp3/ogg}"' '{}' \;

# Set the output quality by adjusting the value of -q:a: for this codec the range is 0-10 and higher gives better quality.
# On older versions of ffmpeg, you may need to use -acodec and -aq instead of -c:a and -q:a.
# Of course, converting from one lossy format to another is not ideal; but such is life.
