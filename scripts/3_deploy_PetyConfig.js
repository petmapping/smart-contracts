const hre = require("hardhat");
const deployed = require("../deployed.json");
const fs = require("fs");
const configs = require("../configs");

async function main() {
  const { name } = hre.network;
  const config = configs[name];
  if (
    !config?.petPrices ||
    !config?.petUpgradePrices ||
    !config?.petUpgradeSuccessRates
  )
    throw new Error("Config is incorrect");
  const PetyConfig = await hre.ethers.getContractFactory("PetyConfig");
  const petyConfig = await hre.upgrades.deployProxy(PetyConfig, [
    config.petPrices,
    config.petUpgradePrices,
    config.petUpgradeSuccessRates,
  ]);
  let contract = await petyConfig.deployed();
  console.log("PetyConfig deployed to:", contract.address);
  const newDeployed = {
    ...(deployed ?? []),
    [name]: {
      ...(deployed[name] ?? []),
      petyConfig: contract.address,
    },
  };
  fs.writeFileSync("deployed.json", JSON.stringify(newDeployed, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
