## Installation

```bash
$ npm install truffle -g
$ npm install
```

## Deploy the app

```bash
# testnet
- make sure you have bnb balance in your wallet for deployment. Receive test bnb value from page: https://testnet.binance.org/faucet-smart
- change private key in file .private_key.testnet
- run bellow command:
$ truffle migrate --reset --network testnet

# mainnet
- make sure you have bnb balance in your wallet for deployment.
- change private key in file .private_key.mainnet
- run bellow command:
$ truffle migrate --network bsc
```
