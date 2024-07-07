#!/usr/bin/env liquidsoap

settings.log.stdout.set(true)
settings.log.level.set(2)
settings.log.file.path.set("/var/log/liquidsoap.log")

is_left = 90.
songs = playlist("/media/songs")
jingles = playlist("/media/jingles")

def next()
  uri = list.hd(process.read.lines("next-song"))
  request.create(uri)
end
s = request.dynamic(next)
# r = request.dynamic.list(...)

def queue(remaining, _) =
  log("Queueing with #{remaining} seconds remaining")
  # if not s.fetch() then
  #   log("Fetching next query failed")
  # end
end
s = source.on_end(delay=is_left , s, queue)

main = fallback(track_sensitive=false, [s, songs])
radio = fallback([delay(300., jingles), main])

output.icecast(%mp3, 
  name="Radio Som do Mato",
  genre="Sertanejo",
  description="O melhor do sertanejo!",
  url="https://somdomato.com",
  host="localhost", 
  port=8000, 
  password="hackme", 
  mount="sertanejo.mp3", 
  charset="UTF-8",
  mksafe(radio))







