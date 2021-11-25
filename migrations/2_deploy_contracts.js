const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const MetaMuskToken = artifacts.require("MetaMuskToken");
const MetaMuskTokenV2 = artifacts.require("MetaMuskTokenV2");

// testnet
const START_TIME_ICO = 1636340453;
const END_TIME_ICO = 1667851253;
const TOTAL_AMOUNT_PER_BNB = 40000;
const TOTAL_AMOUNT_PER_BUSD = 10;
const PERCENT_UNLOCK_PER_DAY = 50;  // value * 100
const BUSD_CONTRACT_ADDRESS = '0xed24fc36d5ee211ea25a80239fb8c4cfd80f12ee';
const OPERATOR_ADDRESS = '0x096E36E51AbdAD5387E826Fef1fd0D3B70D3b201';

// for mainnet
// const START_TIME_ICO = 1636340453;
// const END_TIME_ICO = 1667851253;
// const TOTAL_AMOUNT_PER_BNB = 40000;
// const TOTAL_AMOUNT_PER_BUSD = 10;
// const PERCENT_UNLOCK_PER_DAY = 50;  // value * 100
// const BUSD_CONTRACT_ADDRESS = '';
// const OPERATOR_ADDRESS = '';

module.exports = async function (deployer, network) {
    console.log("you are deploying with the network: ", network);

    const instance = await deployProxy(MetaMuskToken, [
        START_TIME_ICO,
        END_TIME_ICO,
        TOTAL_AMOUNT_PER_BNB,
        TOTAL_AMOUNT_PER_BUSD,
        PERCENT_UNLOCK_PER_DAY,
        BUSD_CONTRACT_ADDRESS,
        OPERATOR_ADDRESS
    ], { deployer });

    console.table({
        MetaMuskTokenContract: instance.address
    });
};
