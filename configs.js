const configs = {
  hardhat: {
    petPrices: [0, 1, 2, 4, 6, 10, 15, 20, 50, 80, 100],
    petUpgradePrices: [1, 1, 2, 2, 4, 5, 5, 30, 30, 20, 0],
    petUpgradeSuccessRates: [0, 100, 100, 100, 100, 95, 95, 90, 85, 80, 80],
  },
  bsc_test: {
    aggregator: "0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526",
    router: "0xd99d1c33f9fc3444f8101754abc46c52416550d1", // pancakeswap testnet https://pancakeswap.finance, https://testnet.bscscan.com/tx/0x2bb886bb425c00e56106ae0aee68563a65f3c2a65cd74bdf5a57210a06349f59
    usd: "0xaB1a4d4f1D656d2450692D237fdD6C7f9146e814", // BUSD on bsc testnet
    petPrices: [0, 10, 20, 40, 60, 100, 150, 200, 500, 800, 1000],
    petUpgradePrices: [10, 10, 20, 20, 40, 50, 50, 300, 300, 200, 0],
    petUpgradeSuccessRates: [0, 100, 100, 100, 100, 95, 95, 90, 85, 80, 80],
  },
  bsc_mainnet: {
    aggregator: "0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE",
    router: "0x10ED43C718714eb63d5aA57B78B54704E256024E", // pancakeswap mainnet https://docs.pancakeswap.finance/code/smart-contracts/pancakeswap-exchange/v2/router-v2
    usd: "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56", // BUSD on bsc mainnet
    petPrices: [0, 10, 20, 40, 60, 100, 150, 200, 500, 800, 1000],
    petUpgradePrices: [10, 10, 20, 20, 40, 50, 50, 300, 300, 200, 0],
    petUpgradeSuccessRates: [0, 100, 100, 100, 100, 95, 95, 90, 85, 80, 80],
  },
};

module.exports = configs;
