#!/usr/bin/liquidsoap

%include "settings.liq"

def cross(g)
  crossfade(fade_out=3., fade_in=3., duration=5., g)
end

def next(g)
  def request_function() =
    lines = process.read.lines("curl https://api.somdomato.com/radio#{g}")
    uri = list.hd(default="",lines)
    request.create(uri)
  end
  request.dynamic(request_function)
end

main = next('principal')
#dance = next('dance')
#rock = next('rock')
#seventies = next('70s')
#eighties = next('80s')
#nineties = next('90s')

main = fallback([cross(main), blank()])
# dance = fallback([cross(dance), rhythm])
# rock = fallback([cross(rock), rhythm])
# seventies = fallback([cross(seventies), rhythm])
# eighties = fallback([cross(eighties), rhythm])
# nineties = fallback([cross(nineties), rhythm])

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
  g)