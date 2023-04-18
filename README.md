# docker-bitcoind
Bitcoin Core running on Docker with Prometheus and Grafana

## Motivation

The idea of this project is to spin up a bitcoin core node on a docker container, with container metrics as well as prometheus metrics and visualised with Grafana.

## Notes

This is a bitcoin testnet and has been setup with weak authentication and allows public access should the node be in a public subnet.

## Pre-Requisites

Boot the monitoring stack:

```bash
cd observability
docker-compose up -d
```

Change back to the root project:

```bash
cd ../
```

## Boot Bitcoin

Build the project:

```bash
docker-compose build
```

Start the project:

```bash
docker-compose up -d
```

## Access Bitcoin RPC

- `getblockchaininfo`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ 
```

- `listwallets`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "listwallets", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/
```

- `createwallet`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "createwallet", "params": ["test-wallet"]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/
```

- `getwalletinfo`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getwalletinfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet
```

- `getnewaddress`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getnewaddress", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet
```

- `getaddressesbylabel`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getaddressesbylabel","params": [""]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet
```

- `getaddressinfo`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getaddressinfo", "params": ["_address_"]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet
```

- `getbalance`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getbalance", "params": ["*", 6]}' -H 'content-type: text/plain;’' http://127.0.0.1:18332/wallet/test-wallet
```

- `getbalances`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getbalances", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet
```

- `listtransactions`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "listtransactions", "params": ["*"]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet
```

- `sendtoaddress`

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "sendtoaddress", "params":["_to_address_", 0.01]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/wallet
```

More info:
- https://medium.com/coinmonks/ultimate-guide-to-bitcoin-testnet-fullnode-setup-b83da1bb22e

## Access Grafana

Access grafana on http://localhost:3000


## Resources

Documentation:

- https://developer.bitcoin.org/reference/rpc/

Testnet Faucet:
- https://bitcoinfaucet.uo1.net/

Testnet Blockexplorers:
- https://blockstream.info/testnet/tx/0039094bef10be889162e75dd8dcfb986ad74f556a1c36b3dd2970bd94484ccf

