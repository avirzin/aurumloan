pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

// LoanEscrow.sol - Handles loan collateralization, issuance, and execution
contract LoanEscrow is Ownable {
    IERC20 public tokenizedGold;
    IERC20 public tokenizedMoney;

    struct Loan {
        address borrower;
        uint256 goldCollateral;
        uint256 loanAmount;
        uint256 dueDate;
        bool repaid;
    }

    mapping(address => Loan) public loans;

    event LoanRequested(address indexed borrower, uint256 goldCollateral, uint256 loanAmount, uint256 dueDate);
    event LoanRepaid(address indexed borrower);
    event CollateralExecuted(address indexed borrower);

    constructor(address _tokenizedGold, address _tokenizedMoney) {
        tokenizedGold = IERC20(_tokenizedGold);
        tokenizedMoney = IERC20(_tokenizedMoney);
    }

    function requestLoan(uint256 _goldAmount, uint256 _loanAmount, uint256 _duration) external {
        require(loans[msg.sender].borrower == address(0), "Active loan exists");
        require(tokenizedGold.transferFrom(msg.sender, address(this), _goldAmount), "Collateral transfer failed");

        uint256 dueDate = block.timestamp + _duration;
        loans[msg.sender] = Loan(msg.sender, _goldAmount, _loanAmount, dueDate, false);

        require(tokenizedMoney.transfer(msg.sender, _loanAmount), "Loan transfer failed");
        emit LoanRequested(msg.sender, _goldAmount, _loanAmount, dueDate);
    }

    function repayLoan() external {
        Loan storage loan = loans[msg.sender];
        require(loan.borrower == msg.sender, "No active loan");
        require(!loan.repaid, "Loan already repaid");
        require(block.timestamp <= loan.dueDate, "Loan overdue");

        require(tokenizedMoney.transferFrom(msg.sender, address(this), loan.loanAmount), "Repayment failed");
        require(tokenizedGold.transfer(msg.sender, loan.goldCollateral), "Collateral return failed");
        
        loan.repaid = true;
        emit LoanRepaid(msg.sender);
    }

    function executeCollateral(address _borrower) external onlyOwner {
        Loan storage loan = loans[_borrower];
        require(loan.borrower != address(0), "No active loan");
        require(block.timestamp > loan.dueDate, "Loan not overdue");
        require(!loan.repaid, "Loan already repaid");

        require(tokenizedGold.transfer(owner(), loan.goldCollateral), "Collateral execution failed");
        delete loans[_borrower];
        emit CollateralExecuted(_borrower);
    }
}