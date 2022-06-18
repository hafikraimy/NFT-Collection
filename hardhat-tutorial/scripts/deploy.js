const { ethers } = require("hardhat");
require("dotenv").config({path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
    const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
    const metadataUrl = METADATA_URL;

    const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");

    const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
        metadataUrl,
        whitelistContract
    );

    console.log("Crypto Devs Contract Address", deployedCryptoDevsContract.address)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });