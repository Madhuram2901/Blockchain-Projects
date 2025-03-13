// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

contract Wallet{
    struct wall{
        address owner;
        uint amount;
        uint time;
    }

    mapping(address =>wall) public Waleet;

    event Deposited(address owner, uint amount, uint time);
    event Withdrawn(address owner, uint amount, uint time);

    modifier minimum(){
        require(msg.value>=1 ether, "Transaction below 1 ETH cannot be done, the value should be more than 1 ETH.");
        _;
    }

    function deposit() public payable minimum{
        Waleet[msg.sender] = wall(msg.sender, msg.value, block.timestamp);
        emit Deposited(msg.sender, msg.value, block.timestamp);
    }
    function withdraw(uint _ethAmount) public {
    uint amountInWei = _ethAmount * 1 ether;

    wall storage userWallet = Waleet[msg.sender];  
    require(userWallet.amount >= amountInWei, "Insufficient balance");

    userWallet.amount -= amountInWei;  

    payable(msg.sender).transfer(amountInWei);
    emit Withdrawn(msg.sender, amountInWei, block.timestamp);
}


    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }


}