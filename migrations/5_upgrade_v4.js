const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const MetaMuskTokenV4 = artifacts.require("MetaMuskTokenV4");

module.exports = async function (deployer, network) {
    console.log("you are deploying with the network: ", network);

    const newInstance = await upgradeProxy("0x734c5f3f8f6ad9697b26ecc6388678aafd3db3b2", MetaMuskTokenV4, { deployer });
    console.table({
        MetaMuskTokenContractV3: newInstance.address
    });
};
