output.icecast(
  %vorbis(samplerate = 44100, channels = 2, quality = 0.4),
  name = "Rádio Som do Mato",
  description = "A mais sertaneja!",
  genre = "Sertanejo",
  url = "https://somdomato.com",
  encoding = "UTF-8",
  host = "localhost", 
  port = 8000,
  password = "hackme", 
  mount = "radio.ogg",
  mksafe(principal)
)