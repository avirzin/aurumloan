const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log(`Deploying contracts with the account: ${deployer.address}`);

    // Deploy TokenizedGold
    const Gold = await ethers.getContractFactory("TokenizedGold");
    const gold = await Gold.deploy();
    await gold.waitForDeployment()
    console.log(`TokenizedGold deployed at: ${gold.target}`);

    // Deploy TokenizedMoney
    const Money = await ethers.getContractFactory("TokenizedMoney");
    const money = await Money.deploy();
    await gold.waitForDeployment()
    console.log(`TokenizedMoney deployed at: ${money.target}`);

    // Deploy LoanEscrow
    const LoanEscrow = await ethers.getContractFactory("LoanEscrow");
    const escrow = await LoanEscrow.deploy(gold.target, money.target);
    await gold.waitForDeployment()
    console.log(`LoanEscrow deployed at: ${escrow.target}`);

    console.log("Deployment successful!");
}

// Run script
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });