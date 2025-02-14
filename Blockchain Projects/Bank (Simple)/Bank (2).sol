// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.19;

contract Bank{
    struct Account{
        address owner;
        uint256 balance;
        uint256 AccTime;
    }

    mapping (address => Account) public LaxmiChitFund;

    event balanceAdded(address owner, uint256 balance , uint256 timeStamp);
    event withdrawalDone(address owner, uint256 balance , uint256 timeStamp);

    modifier minimum(){
        require(msg.value >= 1 ether, "Doesn't follow the minimum criteria");
        _;
    }

    function AccCreated()
    public
    payable
    minimum{
        LaxmiChitFund[msg.sender].owner = msg.sender;
        LaxmiChitFund[msg.sender].balance = msg.value;
        LaxmiChitFund[msg.sender].AccTime = block.timestamp;
        emit balanceAdded(msg.sender, msg.value, block.timestamp);
    }

    function Deposit()
    public
    payable
    minimum{
        LaxmiChitFund[msg.sender].balance += msg.value;
        emit balanceAdded(msg.sender, msg.value, block.timestamp);
    }

    function Withdraw() public payable {
        
        uint amount = msg.value;
        
        require(LaxmiChitFund[msg.sender].balance >= amount, "Insufficient balance");

        LaxmiChitFund[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);

        emit withdrawalDone(msg.sender, LaxmiChitFund[msg.sender].balance, block.timestamp);
}

    
}