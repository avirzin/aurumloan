const { ethers } = require("hardhat");

async function main() {
    const [deployer, client, lender] = await ethers.getSigners();

    // Fetch deployed contract addresses
    const goldAddress = "YOUR_TOKENIZED_GOLD_ADDRESS_HERE";
    const moneyAddress = "YOUR_TOKENIZED_MONEY_ADDRESS_HERE";
    const escrowAddress = "YOUR_LOAN_ESCROW_ADDRESS_HERE";

    // Get contract instances
    const gold = await ethers.getContractAt("TokenizedGold", goldAddress);
    const money = await ethers.getContractAt("TokenizedMoney", moneyAddress);
    const escrow = await ethers.getContractAt("LoanEscrow", escrowAddress);

    console.log("Contracts fetched successfully!");

    // Mint and distribute tokens
    await gold.mint(client.address, ethers.utils.parseEther("100")); // 100 tGOLD
    await money.mint(lender.address, ethers.utils.parseEther("1000")); // 1000 tMONEY

    console.log("Minted 100 tGOLD to Client");
    console.log("Minted 1000 tMONEY to Lender");

    // Client Approves Gold for Collateral
    await gold.connect(client).approve(escrow.address, ethers.utils.parseEther("50")); // Approve 50 tGOLD

    // Client Requests Loan (50 tGOLD as collateral for 500 tMONEY loan)
    const duration = 7 * 24 * 60 * 60; // 7 days in seconds
    await escrow.connect(client).requestLoan(ethers.utils.parseEther("50"), ethers.utils.parseEther("500"), duration);

    console.log("Loan Requested: 50 tGOLD locked as collateral, 500 tMONEY received");

    // Verify Balances
    let clientGoldBalance = await gold.balanceOf(client.address);
    let clientMoneyBalance = await money.balanceOf(client.address);
    let lenderMoneyBalance = await money.balanceOf(lender.address);
    let escrowGoldBalance = await gold.balanceOf(escrow.address);

    console.log(`Client tGOLD Balance: ${ethers.utils.formatEther(clientGoldBalance)}`);
    console.log(`Client tMONEY Balance: ${ethers.utils.formatEther(clientMoneyBalance)}`);
    console.log(`Lender tMONEY Balance: ${ethers.utils.formatEther(lenderMoneyBalance)}`);
    console.log(`Escrow tGOLD Balance: ${ethers.utils.formatEther(escrowGoldBalance)}`);
}

// Run script
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });