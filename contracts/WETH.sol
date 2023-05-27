//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20{
	address immutable owner;
	constructor() ERC20("MyTokens", "MTK"){
		owner = msg.sender;
	}

	function getTokens()
		payable
		external
	{
		_mint(msg.sender, msg.value);	
	}

	function claimETH()	
		external
	{
		require(msg.sender == owner, "Not owner");
		payable(owner).transfer(address(this).balance);
	}
}