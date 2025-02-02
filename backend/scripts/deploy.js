const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log(`Deploying contracts with the account: ${deployer.address}`);

    // Deploy TokenizedGold
    const Gold = await ethers.getContractFactory("TokenizedGold");
    const gold = await Gold.deploy();
    await gold.deployed();
    console.log(`TokenizedGold deployed at: ${gold.address}`);

    // Deploy TokenizedMoney
    const Money = await ethers.getContractFactory("TokenizedMoney");
    const money = await Money.deploy();
    await money.deployed();
    console.log(`TokenizedMoney deployed at: ${money.address}`);

    // Deploy LoanEscrow
    const LoanEscrow = await ethers.getContractFactory("LoanEscrow");
    const escrow = await LoanEscrow.deploy(gold.address, money.address);
    await escrow.deployed();
    console.log(`LoanEscrow deployed at: ${escrow.address}`);

    console.log("Deployment successful!");
}

// Run script
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });