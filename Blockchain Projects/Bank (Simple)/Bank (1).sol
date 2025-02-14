// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

contract Bank{
    struct Account{
        address owner;
        uint256 balance;
        uint256 AccTime;
    }

    mapping (address => Account) public LaxmiChitFund;

    event balanceAdded(address owner, uint256 balance, uint256 timeStamp);
    event WithdrawalDone(address owner, uint256 balance, uint256 timeStamp);

    modifier minimum(){
        require(msg.value >= 1 ether, "Doesn't follow minimum criteria");
        _;
    }

    function AccountCreated()
    public 
    payable
    minimum{
        LaxmiChitFund[msg.sender].owner = msg.sender;
        LaxmiChitFund[msg.sender].balance = msg.value;
        LaxmiChitFund[msg.sender].AccTime= block.timestamp;
        emit balanceAdded(msg.sender, msg.value, block.timestamp);
    }

    function depositDone()
    public
    payable
    minimum{
        LaxmiChitFund[msg.sender].balance += msg.value;
        emit balanceAdded(msg.sender, msg.value, block.timestamp);
    }

    function Withdrawal()
    public 
    payable{
        payable(msg.sender).transfer(LaxmiChitFund[msg.sender].balance);
        LaxmiChitFund[msg.sender].balance = 0;
        emit WithdrawalDone(msg.sender, LaxmiChitFund[msg.sender].balance, block.timestamp);
    }





}