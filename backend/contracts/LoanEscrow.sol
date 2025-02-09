// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title LoanEscrow
 * @dev Manages loan requests, funding, repayments, and collateral execution.
 *      Uses tokenized assets (TokenizedGold and TokenizedMoney) but does NOT own them.
 */
contract LoanEscrow is Ownable {
    IERC20 public tokenizedGold;  // Reference to external TokenizedGold contract
    IERC20 public tokenizedMoney; // Reference to external TokenizedMoney contract

    struct Loan {
        address borrower;
        uint256 goldCollateral;
        uint256 loanAmount;
        uint256 dueDate;
        bool repaid;
    }

    mapping(address => Loan) public loans;

    event LoanRequested(address indexed borrower, uint256 goldCollateral, uint256 loanAmount, uint256 dueDate);
    event LoanFunded(address indexed lender, address indexed borrower, uint256 loanAmount);
    event LoanRepaid(address indexed borrower);
    event CollateralExecuted(address indexed borrower);

    /**
     * @dev Constructor initializes the contract with token contract addresses.
     * @param _tokenizedGold Address of the TokenizedGold contract
     * @param _tokenizedMoney Address of the TokenizedMoney contract
     */
    constructor(address _tokenizedGold, address _tokenizedMoney) {
        tokenizedGold = IERC20(_tokenizedGold);
        tokenizedMoney = IERC20(_tokenizedMoney);
    }

    /**
     * @notice Client requests a loan by locking tGOLD collateral.
     * @param _goldAmount Amount of tokenized gold to lock as collateral.
     * @param _loanAmount Loan amount in tMONEY to request.
     * @param _duration Loan repayment duration in seconds.
     */
    function requestLoan(uint256 _goldAmount, uint256 _loanAmount, uint256 _duration) external {
        require(loans[msg.sender].borrower == address(0), "Active loan exists");
        
        // ✅ Transfer tGOLD from borrower to Escrow contract (Collateral Locking)
        require(tokenizedGold.transferFrom(msg.sender, address(this), _goldAmount), "Collateral transfer failed");

        uint256 dueDate = block.timestamp + _duration;
        loans[msg.sender] = Loan(msg.sender, _goldAmount, _loanAmount, dueDate, false);

        emit LoanRequested(msg.sender, _goldAmount, _loanAmount, dueDate);
    }

    /**
     * @notice Lender funds a loan after reviewing requests.
     * @param _borrower Address of the borrower whose loan will be funded.
     */
    function fundLoan(address _borrower) external {
        Loan storage loan = loans[_borrower];
        require(loan.borrower != address(0), "No active loan request");
        require(!loan.repaid, "Loan already funded");

        // ✅ Transfer tMONEY from Lender to Borrower
        require(tokenizedMoney.transferFrom(msg.sender, loan.borrower, loan.loanAmount), "Loan funding failed");

        emit LoanFunded(msg.sender, _borrower, loan.loanAmount);
    }

    /**
     * @notice Borrower repays the loan in tMONEY to recover their collateral.
     */
    function repayLoan() external {
        Loan storage loan = loans[msg.sender];
        require(loan.borrower == msg.sender, "No active loan");
        require(!loan.repaid, "Loan already repaid");
        require(block.timestamp <= loan.dueDate, "Loan overdue");

        // ✅ Transfer tMONEY from Borrower to Lender
        require(tokenizedMoney.transferFrom(msg.sender, owner(), loan.loanAmount), "Repayment failed");
        
        // ✅ Return tGOLD to Borrower
        require(tokenizedGold.transfer(msg.sender, loan.goldCollateral), "Collateral return failed");

        loan.repaid = true;
        emit LoanRepaid(msg.sender);
    }

    /**
     * @notice Executes collateral transfer to the lender if the borrower defaults.
     * @param _borrower Address of the borrower in default.
     */
    function executeCollateral(address _borrower) external {
        Loan storage loan = loans[_borrower];
        require(loan.borrower != address(0), "No active loan");
        require(block.timestamp > loan.dueDate, "Loan not overdue");
        require(!loan.repaid, "Loan already repaid");

        // ✅ Transfer tGOLD collateral to Lender (Owner)
        require(tokenizedGold.transfer(owner(), loan.goldCollateral), "Collateral execution failed");

        delete loans[_borrower];
        emit CollateralExecuted(_borrower);
    }

    /**
     * @notice Returns the details of all pending loan requests.
     */
    function getPendingLoans(address _borrower) external view returns (Loan memory) {
        return loans[_borrower];
    }
}