pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title  TokenizedMoney
 * @dev    ERC-20 token representing tokenized money, which is issued as a loan in the AurumLoan system.
 *         The contract allows an owner to mint new tokens and transfer them between users.
 *         Borrowers receive this token as loan proceeds when they lock tokenized gold in escrow.
 * @notice This contract represents a tokenized form of money (ERC-20). Borrowers receive 
 *         this token when they take a loan, and they must repay it to retrieve their collateral.
 */

contract TokenizedMoney is ERC20, Ownable {
    constructor() ERC20("Tokenized Money", "tMONEY") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Initial supply
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}