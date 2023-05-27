//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WETH.sol";

contract CrowdFund{
	event Launched
	(
		address creator, 
		uint amountNeeded, 
		uint32 startsIn, 
		uint32 endsIn, 
		uint amountPledged,
		uint campaignId
	);

	event Cancelled
	(
		uint id
	);

	event Pledged
	(
		uint indexed id, 
		address indexed caller, 
		uint amount
	);

	event Unpledged
	(
		uint id, 
		address caller
	);


	struct Campaign{
		address creator;
		uint amountNeeded;
		uint32 startsIn;
		uint32 endsIn;
		uint amountPledged;
		bool claimed;
	}

	WETH immutable token;

	constructor(address _token){
		token = WETH(_token);
	}

	uint campaignId;

	Campaign[] private campaign;
	mapping(address => mapping(uint => uint)) private userPledge;

	function launchCampaign
		(
			uint _amountNeeded, 
			uint32 _endsIn
		)
		external
	{		
		require(_endsIn + block.timestamp <= block.timestamp + 90 days,"90 days Max period");
		
		campaignId++;
		campaign.push(Campaign
			(
				{
					creator: msg.sender,
					amountNeeded: _amountNeeded,
					startsIn: uint32(block.timestamp),
					endsIn: _endsIn + uint32(block.timestamp),
					amountPledged: 0,
					claimed: false
				}
			)
		);

		emit Launched(msg.sender, _amountNeeded, uint32(block.timestamp), _endsIn, 0, campaignId);
	}


	function cancel(uint _id)
		external
	{
		Campaign storage campaign_current = campaign[_id];
		require(msg.sender == campaign_current.creator, "Not creator");
		require(campaign_current.startsIn >= block.timestamp, "Already started");

		delete(campaign[_id]);

		emit Cancelled(_id);
	}

	function pledge(uint _id, uint _amount)
		public
	{	
		Campaign storage campaign_current = campaign[_id];
		require(_amount > 0, "Cant plegde 0 tokens");
		require(campaign_current.endsIn > block.timestamp, "Already ended");
		require(campaign_current.amountPledged <= campaign_current.amountNeeded, "Reach needed amount");
		
		campaign_current.amountPledged += _amount;
		
		if(userPledge[msg.sender][_id] > 0)
		{	
			userPledge[msg.sender][_id] += _amount;
		}
		else{
			userPledge[msg.sender][_id] = _amount;
		}
		
		emit Pledged(_id, msg.sender, _amount);
		require(token.transferFrom(msg.sender, address(this), _amount) == true);
	}

	function unpledge(uint _id)
		external
	{	
		Campaign storage campaign_current = campaign[_id];
		uint _pledge = userPledge[msg.sender][_id];
		require(userPledge[msg.sender][_id] > 0,"No record of your pledge");

		userPledge[msg.sender][_id] -= _pledge;
		campaign_current.amountPledged -= _pledge;

		emit Unpledged(_id, msg.sender);
		require(token.transfer(msg.sender, _pledge));
		
	}

	
	function claim(uint _id)
		external
	{
		Campaign storage campaign_current = campaign[_id];
		require(msg.sender == campaign_current.creator, "Invalid user");
		require(campaign_current.claimed == false, "Already claimed");

		campaign_current.claimed = true;
		uint _amount = campaign_current.amountPledged;
		campaign_current.amountPledged -= _amount;
		require(token.transfer(msg.sender, _amount), "Didnt transfer");

		
	}

	function refund(uint _id)
		external
	{
		Campaign storage campaign_current = campaign[_id];
		require(campaign_current.endsIn < block.timestamp, "Still ongoing");
		require(campaign_current.amountPledged < campaign_current.amountNeeded, "Required amount gotten");
		require(userPledge[msg.sender][_id] > 0, "No pledge found");

		uint _amount = userPledge[msg.sender][_id];
		userPledge[msg.sender][_id] -= _amount;
		campaign_current.amountPledged -= _amount;
		require(token.transfer(msg.sender, _amount), "Didnt transfer");
		
	}

	function getPledge(uint _id)
		view 
		external 
		returns(uint256 _amount)
	{
		_amount = userPledge[msg.sender][_id];
	}

	function getTotalPledge(uint _id)
		view 
		external
		returns(uint256 _amount)
	{
		_amount = campaign[_id].amountPledged;
	}

	function getTokenAmountNeeded(uint _id)
		view
		external 
		returns(uint256 _amount)
	{
		_amount = campaign[_id].amountPledged;
	}
}