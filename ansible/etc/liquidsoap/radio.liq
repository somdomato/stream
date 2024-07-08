#!/usr/bin/env liquidsoap

%include "settings.liq"

is_left = 90.

# default = single("~/radio/default.ogg")
songs = playlist("/media/songs")
jingles = playlist("/media/jingles")
live = input.harbor("aovivo", name="Radio Som do Mato", description="A mais sertaneja!", port=8010, username="dj", password="hackme")

# Play user requests if there are any,
# otherwise one of our playlists,
# and the default file if anything goes wrong.
# radio = fallback([ request.queue(id="request"), switch([({ 6h-22h }, day), ({ 22h-6h }, night)]), default])

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
radio = fallback([delay(600., jingles), main])
full = fallback(track_sensitive=false, [live, radio])

output.icecast(%mp3, 
  name="Radio Som do Mato",
  genre="Sertanejo",
  description="A mais sertaneja!",
  url="https://somdomato.com",
  host="localhost", 
  port=8000, 
  password="hackme", 
  mount="sertanejo.mp3", 
  encoding="UTF-8",
  mksafe(full))