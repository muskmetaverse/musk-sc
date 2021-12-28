const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const MetaMuskToken = artifacts.require("MetaMuskToken");
const MetaMuskTokenV5 = artifacts.require("MetaMuskTokenV5");

module.exports = async function (deployer, network) {
    console.log("you are deploying with the network: ", network);

    const newInstance = await upgradeProxy("0x734c5F3f8F6ad9697b26eCC6388678aaFd3dB3B2", MetaMuskTokenV5, { deployer });
    console.table({
        MetaMuskTokenV5: newInstance.address
    });
};
