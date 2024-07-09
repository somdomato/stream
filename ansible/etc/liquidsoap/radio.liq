#!/usr/bin/liquidsoap

%include "settings.liq"

s = single("/media/jingles/050723 RADIO SOM DO MATO VINHETA 001.mp3")
j = playlist("/media/jingles")
l = input.harbor("aovivo", port=8010, user="dj", password="hackme")

def next()
  def request_function() =
    uri = list.hd(process.read.lines("next-song"))
    request.create(uri)
  end
  [request.dynamic(request_function)]
end

def queue(remaining, _) =
  log("Queueing with #{remaining} seconds remaining")
end

r = source.on_end(delay=.30, next, queue)
m = fallback([delay(1200., jingles), r])
g = fallback(track_sensitive=false, [l, m, s])

output.icecast(%vorbis(samplerate = 44100, channels = 2, quality = 0.4),
  name = "Rádio Som do Mato",
  description = "A mais sertaneja!",
  genre = "Sertanejo",
  url = "https://somdomato.com",
  encoding = "UTF-8",
  host = "localhost", 
  port = 8000,
  password = "hackme", 
  bitrate = 128,
  mount = "radio.ogg",
  g)