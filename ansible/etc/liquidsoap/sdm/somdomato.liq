#!/usr/bin/env liquidsoap

def next(g)
  def request_function() =
    lines = process.read.lines("curl https://api.somdomato.com#{g}")
    uri = list.hd(default="",lines)
    request.create(uri)
  end
  request.dynamic(request_function)
end

principal = next('')
# modao = next('/modao')
# romantico = next('/romantico')
# universitario = next('/universitario')

%include "outputs.ogg.liq"