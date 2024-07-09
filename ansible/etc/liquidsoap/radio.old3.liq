#!/usr/bin/liquidsoap

%include "settings.liq"

security = single("/media/jingles/050723 RADIO SOM DO MATO VINHETA 001.mp3")
jingles = playlist("/media/jingles")
live = input.harbor("aovivo", port=8010, user="dj", password="hackme")

# def next_song(genre)
#   def request_function() =
#     uri = list.hd(process.read.lines("next-song #{genre}"))
#     request.create(uri)
#   end
#   request.dynamic(prefetch=0, request_function)
# end

def queue(remaining, _) =
  log("Queueing with #{remaining} seconds remaining")
end

# def fetch(s) =
#   thread.run(fun () -> begin
#     if not s.fetch() then
#       log("Error fetching")
#     end
#   end)
# end

# s = next_song("sertanejo")

# Initial request
# fetch(s)

# Fetch next song 10. before the current one ends
# s = source.on_end(delay=10., fun (_, _) -> fetch(s), s)

def my_request_function() =
  result = list.hd(default="", process.read.lines("next-song"))
  request.create(result)
end

# Create the source
s = request.dynamic(my_request_function)
s = source.on_end(delay=.90, s)

geral = fallback([delay(1200., jingles), s])
geral = fallback(track_sensitive=false, [live, geral])
geral = fallback(track_sensitive=false, [geral, security])

# uni = source.on_end(delay=is_left, next("universitario"), queue)
# uni = fallback([delay(1200., jingles), uni])
# uni = fallback(track_sensitive=false, [live, uni])
# uni = fallback(track_sensitive = false, [uni, security])

# modao = source.on_end(delay=is_left, next("modao"), queue)
# modao = fallback([delay(1200., jingles), modao])
# modao = fallback(track_sensitive=false, [live, modao])
# modao = fallback(track_sensitive = false, [modao, security])

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
  mksafe(geral))

# output.icecast(%mp3, 
#   name="Rádio Som do Mato",
#   description="Sertanejo Universitário",
#   genre="Sertanejo",
#   url="https://somdomato.com",
#   host="localhost", 
#   port=8002, 
#   password="hackme", 
#   mount="universitario.mp3", 
#   encoding="UTF-8",
#   mksafe(uni))

# output.icecast(%mp3, 
#   name="Rádio Som do Mato",
#   description="Moda de Viola",
#   genre="Sertanejo",
#   url="https://somdomato.com",
#   host="localhost", 
#   port=8004, 
#   password="hackme", 
#   mount="modao.mp3", 
#   encoding="UTF-8",
#   mksafe(modao))