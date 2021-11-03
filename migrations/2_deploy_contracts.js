const NFTZEN = artifacts.require("NFTZEN");
const Marketplace = artifacts.require("Marketplace");

// testnet
const OWNER = '0x44F466f594D336e338042Db1f3Be0dcA1c630E24';

// for mainnet
// const OWNER = '';

module.exports = async function (deployer, network) {
    console.log("you are deploying with the network: ", network);

    let owner = OWNER;

    await deployer.deploy(NFTZEN);

    console.table({
        NFTZEN: NFTZEN.address
    });

    await deployer.deploy(Marketplace,
        NFTZEN.address,
        owner);

    console.table({
        Marketplace: Marketplace.address
    });
};
