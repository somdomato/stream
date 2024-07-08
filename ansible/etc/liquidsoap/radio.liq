#!/usr/bin/env liquidsoap

settings.log.stdout.set(true)
settings.log.level.set(2)
settings.log.file.path.set("/var/log/liquidsoap.log")

is_left = 90.
songs = playlist("/media/songs")
jingles = playlist("/media/jingles")

# def next()
#   uri = list.hd(process.read.lines("next-song"))
#   request.create(uri)
# end
# s = request.dynamic(next)

# def next(genre) =
#   result = list.hd(default="", process.read.lines("next-song #{genre}"))
#   [request.create(result)]
# end
# s = request.dynamic.list(next("sertanejo"))

# def cross(g)
#   crossfade(fade_out=3., fade_in=3., duration=5., g)
# end

def next(genre)
  def request_function() =
    uri = list.hd(process.read.lines("next-song #{genre}"))
    request.create(uri)
  end
  request.dynamic(request_function)
end


def queue(remaining, _) =
  log("Queueing with #{remaining} seconds remaining")
  # if not s.fetch() then
  #   log("Fetching next query failed")
  # end
end
s = source.on_end(delay=is_left , next("sertanejo"), queue)

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







