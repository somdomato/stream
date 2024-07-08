#!/usr/bin/env liquidsoap

%include "settings.liq"

is_left = 90.

# default = single("~/radio/default.ogg")
songs = playlist("/media/songs")
jingles = playlist("/media/jingles")
live = input.harbor("aovivo", port=8010, password="hackme")

# Play user requests if there are any,
# otherwise one of our playlists,
# and the default file if anything goes wrong.
# radio = fallback([ request.queue(id="request"), switch([({ 6h-22h }, day), ({ 22h-6h }, night)]), default])

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
full = fallback(track_sensitive=false, [live, radio])

output.icecast(%mp3, 
  name="Radio Som do Mato",
  genre="Sertanejo",
  description="O melhor do sertanejo!",
  url="https://somdomato.com",
  host="localhost", 
  port=8000, 
  password="hackme", 
  mount="sertanejo.mp3", 
  encoding="UTF-8",
  mksafe(full))







