output.icecast(
  %mp3(bitrate=128, samplerate=44100, id3v2=true), 
  name = "Rádio Som do Mato",
  description = "A mais sertaneja!",
  genre = "Sertanejo",
  url = "https://somdomato.com",
  host = "localhost", 
  port = 8000, 
  password = "hackme", 
  mount = "radio.mp3", 
  encoding = "UTF-8",
  mksafe(principal))