#!/usr/bin/liquidsoap

%include "settings.liq"

def get_request() =
  result = process.read.lines("next-song")
  request.create(list.hd(result))
  #request.create(list.hd(default="", result))
end
r = request.dynamic(get_request)

# j = playlist("/media/jingles")
# l = input.harbor("aovivo", port=8010, user="dj", password="hackme")
# m = fallback([delay(1200., j), r])
# g = fallback(track_sensitive=false, [l, m, s])

output.icecast(%vorbis(samplerate = 44100, channels = 2, quality = 0.4),
  name = "Rádio Som do Mato",
  description = "A mais sertaneja!",
  genre = "Sertanejo",
  url = "https://somdomato.com",
  encoding = "UTF-8",
  host = "localhost", 
  port = 8000,
  password = "hackme", 
  mount = "radio.ogg",
  mksafe(g)
  )