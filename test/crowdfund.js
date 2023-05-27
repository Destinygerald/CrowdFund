const WETH = artifacts.require("WETH");
const CrowdFund = artifacts.require("CrowdFund");

const Web3 = require('web3');
const web3 = new Web3();

contract("CrowdFund", (accounts) => {
	let Crowdfund = null;
	let Weth = null;

	before(async() => {
		Weth = await WETH.deployed();
		Crowdfund = await CrowdFund.deployed();
	})

	it('Should Buy Tokens', async() => {
		await Weth.getTokens({
			from: accounts[1],
			to: Weth.address,
			value: web3.utils.toWei('2', 'ether')
		});
	})

	it ('Should grant approval', async() => {
		let approved = await Weth.approve(Crowdfund.address, 10000000, {from: accounts[1]});
		console.log(approved);
	})

	it('Should return tokens balance', async() => {
		let balance = await Weth.balanceOf(accounts[1]);
		console.log(balance.toString());
		console.log(web3.utils.toBN(balance));
	})


	it('Should launch a Campaign', async() => {
		let launch = await Crowdfund.launchCampaign(100000, 2 * 60);
//											         1682517378
		console.log(launch);
	})

	it('Should get users pledge', async() => {
		let amount = await Crowdfund.getPledge(0, {from: accounts[1]});
		console.log(amount.toString());
	})


	it('Should pledge to a campaign', async() => {
		await Crowdfund.pledge(0, 500000, {from: accounts[1]});
	})

	it('Should get users pledge', async() => {
		let amount = await Crowdfund.getPledge(0, {from: accounts[1]});
		console.log(amount.toString());
	})

	it('Should get total pledge', async() => {
		let amount = await Crowdfund.getTotalPledge(0);
		console.log(amount.toString());
	})


	it('Should get Token balance', async() => {
		let balance = await Weth.balanceOf(accounts[1]);
		console.log(balance.toString());
	})

	it('Should unpledge to a campaign', async() => {
		await Crowdfund.unpledge(0, {from: accounts[1]});
	})

	it('Should get users pledge', async() => {
		let amount = await Crowdfund.getPledge(0, {from: accounts[1]});
		console.log(amount.toString());
	})

	it('Should get total pledge', async() => {
		let amount = await Crowdfund.getTotalPledge(0);
		console.log(amount.toString());
	})


	it('Should get Token balance', async() => {
		let balance = await Weth.balanceOf(accounts[1]);
		console.log(balance.toString());
	})

})