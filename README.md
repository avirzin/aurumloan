<img src="./images/aurum_bar.png" alt="bernie logo" width="100"/>

# Aurum Loan


## Overview
AurumLoan is a smart contract-based simulation demonstrating how tokenized gold can be used as collateral for loans in tokenized money (ERC-20). An escrow contract securely holds the gold until the loan is repaid, ensuring proper execution of the lending process.

## Features
- **Metamask Integration**: Users can connect their wallets to interact with the protocol.
- **Tokenized Gold as Collateral**: Users deposit tokenized gold into an escrow contract.
- **Loan Issuance**: Users receive tokenized money (ERC-20) equivalent to the loan amount.
- **Automated Repayment Flow**: Borrowers can repay loans before the due date to reclaim their collateral.
- **Collateral Execution**: If the borrower defaults, the collateral is transferred to the lender.

## How It Works
1. **User Requests a Loan**: The borrower locks tokenized gold in the escrow smart contract.
2. **Loan Disbursement**: The smart contract transfers tokenized money to the borrower.
3. **Repayment Flow**:
   - If repaid before the due date, the gold is returned to the borrower.
   - If the borrower defaults, the escrow contract transfers the gold to the lender.

### Use case diagram

### Sequence diagram

### Class diagram

## Technology Stack
- **Smart Contracts**: Solidity, Hardhat
- **Blockchain Network**: Ethereum Testnet (Alchemy RPC)
- **Front-End**: React (with Wagmi, Ethers.js, RainbowKit)
- **Security**: OpenZeppelin libraries for secure smart contract development

## Smart Contracts
- `TokenizedGold.sol`: ERC-20 contract representing tokenized gold.
- `TokenizedMoney.sol`: ERC-20 contract representing the loan currency.
- `LoanEscrow.sol`: Handles the collateralization, loan issuance, repayment, and liquidation.

```
│── /backend
│   ├── /contracts      # Solidity smart contracts
│   ├── /scripts        # Deployment scripts
│   ├── /test           # Smart contract tests
│── /frontend
│   ├── /src
│   │   ├── /components # React UI components
│   │   ├── /pages      # Loan request, repayment UI
│   │   ├── /hooks      # Blockchain interactions
│── /deployments        # Deployed contract addresses
│── .env                # Environment variables
│── README.md           # Project documentation
```

## Deployment & Testing
1. Clone the repository:
```
   git clone https://github.com/yourusername/AurumLoan.git
   cd AurumLoan
```

2. Install the dependencies:
   ```sh
   cd backend && npm install
   cd ../frontend && npm install
   ```

3. Deploy smart contracts:
   ```sh
   npx hardhat run scripts/deploy.js --network sepolia
   ```

4. Start the front-end:
    ```sh
    cd frontend
    npm start
    ```


## License
This project is licensed under the [MIT License](./LICENSE)