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
### To launch the console, run the command: 
  ```
  truffle console --network testnet
  ```
### Create a new abstraction to represent the contract at that address:
  ```
  let specificInstance = await MetaMuskToken.at("MetaMusk Contract Address")
  ```
### Making a call to buy ICO buy bnb
  ```
  let result = await specificInstance.buyICO({from: accounts[0], value: web3.utils.toWei('0.01', 'ether')})
  ```
### Making a call to buy ICO buy BUSD
- to approve BUSD for our contract, go to this link: https://testnet.bscscan.com/address/0xed24fc36d5ee211ea25a80239fb8c4cfd80f12ee#writeContract (in this case, we are using BUSD contract address 0xed24fc36d5ee211ea25a80239fb8c4cfd80f12ee to integrate with MetaMusk token, you can change BUSD contract address by other BUSD contract address)
- connect to Web3 by wallet that you are using to test in truffle console
- at "2. approve" tab method, please fill "_spender" with MetaMusk contract address and fill "_value" equal the value that you are using to buyICOByBUSD (the value in wei format)
- click "Write" button
- go back to truffle console and run bellow command:
  ```
  let result = await specificInstance.buyICOByBUSD(web3.utils.toWei('1', 'ether'), {from: accounts[0]})
  ```