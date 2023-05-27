const WETH = artifacts.require("WETH");
const CrowdFund = artifacts.require("CrowdFund");

module.exports = async(deployer) => {
	await deployer.deploy(WETH);
	const wEth = await WETH.deployed();
	await deployer.deploy(CrowdFund, wEth.address);
}