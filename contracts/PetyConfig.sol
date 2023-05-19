// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../interfaces/IUniswapV2Router.sol";
import "../interfaces/IPetyConfig.sol";
import "../interfaces/IFactory.sol";
import "./Pety.sol";

contract PetyConfig is IPetyConfig, OwnableUpgradeable {
    Pety.Level[32] private levels;
    uint32 private tokenomic; // user will be discount 20% if they pay by token
    uint32 private maxLevel;

    function initialize(
        uint32[] memory _prices,
        uint32[] memory _upgradePrices,
        uint8[11] memory _upgradeSuccessRates
    ) public initializer {
        for (uint8 i = 0; i <= 10; i += 1) {
            levels[i].price = _prices[i];
            levels[i].upgradePrice = _upgradePrices[i];
            levels[i].upgradeSuccessRate = _upgradeSuccessRates[i];
        }
        tokenomic = 80000; // 80%
        maxLevel = 10;
        __Ownable_init();
    }

    function getPetyLevel(
        uint8 _level
    ) external view returns (Pety.Level memory) {
        return levels[_level];
    }

    function getTokenomic() external view returns (uint32) {
        return tokenomic;
    }

    function getMaxLevel() external view returns (uint32) {
        return maxLevel;
    }

    function changePrice(uint8 _level, uint32 newPrice) external onlyOwner {
        require(_level <= 30, "level cannot greater than 30");
        require(
            _level <= 1 || levels[_level - 1].price != 0,
            "level is invalid"
        );
        levels[_level].price = newPrice;
        if (_level > maxLevel) {
            maxLevel = _level;
        }
    }

    function changeUpgradePrice(
        uint8 _level,
        uint32 _newUpgradePrice
    ) external onlyOwner {
        require(levels[_level].price != 0 || _level == 0, "level is invalid");
        levels[_level].upgradePrice = _newUpgradePrice;
    }

    function changeUpgradeSuccessRate(
        uint8 _level,
        uint8 newRate
    ) external onlyOwner {
        require(levels[_level].price != 0 || _level == 0, "level is invalid");
        levels[_level].upgradeSuccessRate = newRate;
    }

    function changeTokenomic(uint32 newTokenomic) external onlyOwner {
        tokenomic = newTokenomic;
    }
}
