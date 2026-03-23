# 🌳🎧 Rádio Som do Mato (STREAM)

![Rádio Som do Mato](https://raw.githubusercontent.com/somdomato/somdomato/refs/heads/main/public/images/logo.svg "Rádio Som do Mato")

[![Deploy](https://github.com/somdomato/stream/actions/workflows/deploy.yml/badge.svg)](https://github.com/somdomato/stream/actions/workflows/deploy.yml)

Streaming de audio para as massas.

## Sistemas

| sistema | url | descrição |
| :--- | ---: | ---: |
| [Frontend](https://github.com/somdomato/somdomato/tree/main/frontend) | [somdomato.com](https://somdomato.com) | Frontend da Web Rádio  |
| [Backend](https://github.com/somdomato/somdomato/tree/main/frontend) | [api.somdomato.com](https://api.somdomato.com) | Backend da Web Rádio  |
| Stream | [radio.somdomato.com](https://radio.somdomato.com) | Arquivos de configuração do Icecast e Liquidsoap |
| [Chat](https://github.com/somdomato/chat) | [chat.somdomato.com](https://chat.somdomato.com) | Arquivos de configuração do bate-papo usando IRC(Ergo, Gamja & KiwiIRC) |
| [Podman](https://github.com/somdomato/podman) | - | Imagens e contêineres do Podman para desenvolvimento local. |

## Desenvolvimento Local (Docker)

Espelha o ambiente de produção (Debian 13 amd64) com Icecast2 e Liquidsoap rodando em containers.

### Standalone (só stream, sem Next.js)

```bash
export MUSIC_PATH=/home/lucas/music/sdm
docker compose -f docker/docker-compose.yml up -d --build
```

| Porta | Serviço |
|-------|---------|
| `8000` | Icecast2 – `http://localhost:8000/radio.mp3` |
| `8010` | Liquidsoap Harbor (broadcast ao vivo) |

> Sem o Next.js rodando, o Liquidsoap não consegue buscar músicas via API e ficará aguardando. Útil para testar só o Icecast.

### Integrado (stream + site)

Para simular a VPS1 completa (site + stream juntos), use o Makefile na raiz do monorepo:

```bash
# Na raiz do monorepo (pasta sdm/)
export MUSIC_PATH=/home/lucas/music/sdm
make vps1
```

Isso sobe o Next.js (`somdomato/`), Icecast e Liquidsoap (configs de `stream/docker/`) e Nginx na mesma rede Docker.

### Configurações Docker

| Arquivo | Equivalente produção |
|---------|----------------------|
| `docker/icecast.docker.xml` | `ansible/etc/icecast2/somdomato.xml` |
| `docker/somdomato.docker.liq` | `ansible/etc/liquidsoap/sdm/somdomato.liq` |

Diferenças do Docker vs produção:

| Aspecto | Docker | Produção |
|---------|--------|----------|
| Icecast hostname | `localhost` | `somdomato.com` |
| Liquidsoap API | `http://nextjs:3000` | `http://localhost:3000` |
| Liquidsoap host icecast | `icecast` (Docker DNS) | `localhost` |