#!/usr/bin/liquidsoap

# Music
myplaylist = playlist("/media/songs")

# Some jingles
jingles = playlist("/media/jingles")

# If something goes wrong, we'll play this
security = single("/media/jingles/050723 RADIO SOM DO MATO VINHETA 001.mp3")

# Start building the feed with music
radio = myplaylist

# Now add some jingles
radio = random(weights = [1, 4],[jingles, radio])

# And finally the security
radio = fallback(track_sensitive = false, [radio, security])

# Stream it out
output.icecast(%vorbis,
  host = "localhost", port = 8000,
  password = "hackme", mount = "radio.ogg",
  radio)