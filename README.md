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

## test on console
- refer to: https://www.trufflesuite.com/docs/truffle/testing/testing-your-contracts
- refer to: https://www.trufflesuite.com/docs/truffle/getting-started/interacting-with-your-contracts
- To launch the console, run the command: 
  ```
  truffle console --network testnet
  ```
- Create a new abstraction to represent the contract at that address:
  ```
  let specificInstance = await MetaMuskToken.at("0x1234...")
  ```
- Making a call to buy ICO buy bnb
  ```
  let result = await specificInstance.buyICO({from: accounts[0], value: web3.utils.toWei('0.01', 'ether')})
  ```
- Making a call to buy ICO buy BUSD
  ```
  let result = await specificInstance.buyICOByBUSD(web3.utils.toWei('1', 'ether'), {from: accounts[0]})
  ```