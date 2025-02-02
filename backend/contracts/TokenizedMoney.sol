pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// TokenizedMoney.sol - ERC-20 token representing the loan currency (CBDC-like)
contract TokenizedMoney is ERC20, Ownable {
    constructor() ERC20("Tokenized Money", "tMONEY") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Initial supply
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}