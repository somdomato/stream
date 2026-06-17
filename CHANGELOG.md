# Changelog

## [Não lançado] - 2026-06-17

### Corrigido — Buffering/engasgos no stream para clientes com conectividade instável

**Problema:** dependendo da qualidade de conexão do ouvinte, o áudio travava
brevemente durante a reprodução. A causa raiz era um buffer do Icecast2 muito
pequeno (`queue-size`/`burst-size`), insuficiente para absorver picos de
latência/jitter de rede do lado do cliente — qualquer pequena lentidão fazia
o player reiniciar o buffer, percebido como engasgo.

Ajustados os limites de buffer e timeout em `<limits>` nos dois arquivos de
configuração do Icecast2 (produção e Docker/dev):

- `ansible/etc/icecast2/somdomato.xml`
- `docker/icecast.docker.xml`

| Parâmetro         | Antes    | Depois    | Motivo |
|-------------------|----------|-----------|--------|
| `queue-size`       | `102400` (100 KB ≈ 6,4 s @128 kbps) | `1048576` (1 MB ≈ 65 s @128 kbps) | Buffer de saída por cliente maior — absorve quedas momentâneas de banda do ouvinte sem ele ser desconectado/precisar reconectar (o que soa como travada). |
| `burst-size`       | `65536` (64 KB ≈ 4 s)  | `131072` (128 KB ≈ 8 s) | Envia um "empurrão" inicial maior ao conectar/reconectar, deixando o player com mais áudio pré-carregado e menos sujeito a engasgar logo no início. |
| `client-timeout`   | `30`     | `60`      | Mais tolerância antes de desconectar um cliente lento, em vez de cortar a conexão (causando reconexão audível). |
| `source-timeout`   | `10`     | `30`      | Mais tolerância a pequenas instabilidades na conexão Liquidsoap → Icecast (fonte), evitando que o Icecast derrube a fonte por um soluço passageiro. |

`header-timeout` e `burst-on-connect` não foram alterados (já adequados).

**Não alterado:** a configuração do Liquidsoap (`*.liq`) e do
`input.harbor` (buffer de pré-carregamento da transmissão ao vivo, já em
12s/máx. 20s por padrão) foi inspecionada e considerada adequada — o
problema era no lado do servidor de distribuição (Icecast), não na ingestão
do áudio ao vivo.

**Trade-off:** o aumento do `queue-size`/`burst-size` consome um pouco mais
de memória por cliente conectado (até ~1 MB por ouvinte no pior caso) e
adiciona até ~8s de latência adicional na conexão inicial — aceitável para
uma rádio contínua, onde estabilidade de reprodução importa mais que
latência de início.
