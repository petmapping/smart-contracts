const hre = require("hardhat");
const deployed = require("../deployed.json");
const fs = require("fs");

async function main() {
  const Token = await hre.ethers.getContractFactory("HuraToken");
  const token = await Token.deploy();

  await token.deployed();
  console.log("HuraToken deployed to:", token.address);

  const { name } = hre.network;
  const newDeployed = {
    ...(deployed ?? []),
    [name]: {
      ...(deployed[name] ?? []),
      token: token.address,
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
