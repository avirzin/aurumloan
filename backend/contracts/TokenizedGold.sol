// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title  TokenizedGold
 * @dev    ERC-20 token representing tokenized gold, which can be used as collateral in the AurumLoan system.
 *         The contract allows an owner to mint new tokens and transfer them between users.
 *         Tokenized gold is locked in an escrow smart contract when used as collateral for loans.
 * @notice This contract represents digital gold as an ERC-20 token. Users can hold and transfer 
 *         tokenized gold, and it can be used as collateral for loans in the system.
 */

contract TokenizedGold is ERC20, Ownable {
    constructor() ERC20("Tokenized Gold", "tGOLD") Ownable(msg.sender){
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Initial supply
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}