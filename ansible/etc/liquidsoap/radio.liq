#!/usr/bin/env liquidsoap

is_left = 90.

%include "settings.liq"

songs = playlist("/media/songs")
jingles = playlist("/media/jingles")
live = input.harbor("aovivo", description="A mais sertaneja!", port=8010, user="dj", password="hackme")

def next(genre)
  def request_function() =
    uri = list.hd(process.read.lines("next-song #{genre}"))
    request.create(uri)
  end
  request.dynamic(request_function)
end

def queue(remaining, _) =
  log("Queueing with #{remaining} seconds remaining")
end

geral = source.on_end(delay=is_left , next("sertanejo"), queue)
# main = fallback(track_sensitive=false, [s, songs])
geral = fallback([delay(1200., jingles), geral])
geral = fallback(track_sensitive=false, [live, geral])

uni = source.on_end(delay=is_left , next("universitario"), queue)
uni = fallback([delay(1200., jingles), uni])
uni = fallback(track_sensitive=false, [live, uni])

output.icecast(%mp3, 
  name="Rádio Som do Mato",
  description="A mais sertaneja!",
  genre="Sertanejo",
  url="https://somdomato.com",
  host="localhost", 
  port=8000, 
  password="hackme", 
  mount="sertanejo.mp3", 
  encoding="UTF-8",
  mksafe(full))

  output.icecast(%mp3, 
  name="Rádio Som do Mato",
  description="Sertanejo Universitário",
  genre="Sertanejo",
  url="https://somdomato.com",
  host="localhost", 
  port=8002, 
  password="hackme", 
  mount="universitario.mp3", 
  encoding="UTF-8",
  mksafe(uni))