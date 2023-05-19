const hre = require("hardhat");
const deployed = require("../deployed.json");
const fs = require("fs");
const configs = require("../configs");

async function main() {
    const { name } = hre.network;
    const config = configs[name];
    if (!config?.aggregator || !config?.router || !config?.usd)
        throw new Error("Config is incorrect");
    const Factory = await hre.ethers.getContractFactory("Factory");
    if (!deployed[name]?.token) throw new Error("Deploy token first");
    const factory = await Factory.deploy(
        config.aggregator,
        config.router,
        deployed[name].token,
        config.usd
    );
    await factory.deployed();
    console.log("Factory deployed to:", factory.address);
    const newDeployed = {
        ...(deployed ?? []),
        [name]: {
            ...(deployed[name] ?? []),
            factory: factory.address,
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
