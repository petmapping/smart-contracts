const hre = require("hardhat");
const deployed = require("../deployed.json");
const fs = require("fs");

async function main() {
  const { name } = hre.network;
  if (!deployed[name]?.factory) throw new Error("Deploy Factory first");
  if (!deployed[name]?.petyConfig) throw new Error("Deploy PetyConfig first");
  const Pety = await hre.ethers.getContractFactory("Pety");
  const pety = await hre.upgrades.deployProxy(Pety, [
    deployed[name].factory,
    deployed[name].petyConfig,
  ]);
  let contract = await pety.deployed();
  console.log("Pety deployed to:", contract.address);
  const newDeployed = {
    ...(deployed ?? []),
    [name]: {
      ...(deployed[name] ?? []),
      pety: contract.address,
    },
  };
  fs.writeFileSync("deployed.json", JSON.stringify(newDeployed, null, 2));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
