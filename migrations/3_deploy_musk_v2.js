const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const MetaMuskTokenV2 = artifacts.require("MetaMuskTokenV2");


module.exports = async function (deployer, network) {
    console.log("you are deploying with the network: ", network);

    const newInstance = await upgradeProxy('0x58ADdE577Fe71a4E1e4BA2e4AE5203b877C0F344', MetaMuskTokenV2, { deployer });
    console.table({
        MetaMuskTokenContractV2: newInstance.address
    });
};
