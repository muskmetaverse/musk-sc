const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const MetaMuskAirdrop = artifacts.require("MetaMuskAirdrop");

const METAMUSK_CONTRACT_ADDRESS = '0x96212A889E5Be2c9429700acFa5aA000024D3686';
const OPERATOR_ADDRESS = '0x096E36E51AbdAD5387E826Fef1fd0D3B70D3b201';

module.exports = async function (deployer) {
    const instance = await deployProxy(MetaMuskAirdrop, [
        METAMUSK_CONTRACT_ADDRESS,
        OPERATOR_ADDRESS
    ], { deployer });

    console.table({
        MetaMuskAirdropContract: instance.address
    });
};
