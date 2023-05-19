// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/IUniswapV2Router.sol";

contract MockUniswapV2Router is IUniswapV2Router {
    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        pure
        returns (uint256[] memory)
    {
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = amountIn;
        amounts[1] = amountIn * 2;
        return amounts;
    }
}
