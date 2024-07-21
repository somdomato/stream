#!/usr/bin/env liquidsoap

# %include "outputs.mp3.liq"
settings.harbor.bind_addrs := ["0.0.0.0"]

live = input.harbor("live",port=8080,password="hackme")

def next(g)
  def request_function() =
    lines = process.read.lines("curl https://api.somdomato.com/radio#{g}")
    uri = list.hd(default="",lines)
    request.create(uri)
  end
  request.dynamic(request_function)
end

geral = next('')
# modao = next('/modao')

radio = fallback(track_sensitive=false, [live, geral])
# main = fallback([cross(main), blank()])

%include "outputs.mp3.liq"
