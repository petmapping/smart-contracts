// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MockUSDToken is ERC20, Ownable {
    constructor() ERC20("MockUSD", "MUSD") {
        _mint(address(this), 21 * (10**24));
    }
}
