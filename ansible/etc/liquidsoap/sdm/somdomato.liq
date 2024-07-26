#!/usr/bin/env liquidsoap

live = input.harbor("aovivo", port=8010, user="dj", password="hackme")

# day = playlist("/radio/day.pls") # Day music
# radio = switch([({7h-12h}, manha), ({12h-18h}, tarde), ({18h-0h}, noite), ({0h-7h}, madrugada)])

def next(g)
  def request_function() =
    lines = process.read.lines("curl https://api.somdomato.com/radio#{g}")
    uri = list.hd(default="",lines)
    request.create(uri)
  end
  request.dynamic(request_function)
end

bun = next('')
principal = fallback(track_sensitive=false, [live, bun])

radio = fallback(track_sensitive=false, [live, geral])
# main = fallback([cross(main), blank()])

%include "outputs.mp3.liq"
