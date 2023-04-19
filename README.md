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

## Monitoring Screenshots

Bitcoin Exporter Dashboard:

![image](https://user-images.githubusercontent.com/567298/233106983-ef66ea75-3cbc-43e3-a4b6-de0963ba4851.png)

Bitcoin Container Dashboard:

![image](https://user-images.githubusercontent.com/567298/233107267-02049a12-c995-4077-8f95-78aec7784536.png)

![image](https://user-images.githubusercontent.com/567298/233107710-c925712e-3644-4a15-9318-b4134546a29b.png)

Bitcoin Container Logs:

![image](https://user-images.githubusercontent.com/567298/233108153-f54b2a86-b5dd-4018-9373-e20911955d00.png)


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

To see if a node is out of sync, you can look at blocks vs headers in `getblockchaininfo` but to see how long its out of sync:

```bash
median=$(curl -s -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | jq -r '.result.mediantime')
seconds=$(echo $(date +%s) - $median | bc )
echo $((seconds/86400))" days "$(date -d "1970-01-01 + $seconds seconds" "+%H hours %M minutes %S seconds")
1525 days 10 hours 41 minutes 27 seconds
```

To view the latest blockinfo:

```bash
curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getblockcount", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet | jq -r '.result'
1384738

curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getblockhash", "params": [1384738]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet | jq -r '.result'
00000000000000485f3ab8524134f079b472456a182c22917647abcd04532893

curl -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getblock", "params": ["00000000000000485f3ab8524134f079b472456a182c22917647abcd04532893"]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/test-wallet | jq .

{
  "result": {
    "hash": "00000000000000485f3ab8524134f079b472456a182c22917647abcd04532893",
    "confirmations": 9299,
    "strippedsize": 998027,
    "size": 998606,
    "weight": 3992687,
    "height": 1384738,
    "version": 536870912,
    "versionHex": "20000000",
    "merkleroot": "2bd00b9b1ad746256414fcdb6ebeb4e872a2175cf2cda9986aeacef7e793cd8d",
    "tx": [
      "af319e276e33123f62980b43eb0265772384f433f49dcdbeeef8e6319c806a70",
      "68c26ce2ad7389a71a21d4d037436d73f9dce125488edf85451fda1100a9eb29",
...
```

To see how many blocks still have to sync:

```bash
headers=$(curl -s -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | jq -r '.result.headers')
blocks=$(curl -s -u "bitcoinrpc:bitcoinpass" -d '{"jsonrpc": "1.0", "id": "docker-bitcoind", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | jq -r '.result.blocks')

echo "blocks=$blocks / headers=$headers"
echo "blocks to sync:"
echo "$headers - $blocks" | bc
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

