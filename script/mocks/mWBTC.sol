// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockWBTC is ERC20 {
    constructor() ERC20("Mock WBTC", "mWBTC") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals()))); // Mint 1 million mock WBTC to deployer
    }
}
