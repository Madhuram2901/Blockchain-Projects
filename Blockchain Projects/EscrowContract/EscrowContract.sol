// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.19;

enum Status {Pending, Approved, Disputed}


contract Escrow{
    struct Transaction{
        address sender;
        address receiver;
        uint256 amount;
        Status status;
    }

    mapping (uint => Transaction) transactions;

    uint public transactionCounter;

    event TransactionDone(uint indexed tId, address indexed sender, address indexed receiver, uint256 amount);
    event StatusUpdated(uint indexed tId, Status newStatus);
    event DisputeResolved(uint indexed tId, Status newStatus);
    event WithdrawalDone(uint indexed tId, address indexed receiver, uint256 amount);

    function transact(address receiver, uint amount) payable public{
        require(msg.value == amount, "THe amount doesn't match with the sent value.");
        require(msg.sender != receiver, "The sender and receiver are the same");
        
        transactions[transactionCounter] = Transaction({
            sender: msg.sender,
            receiver: receiver,
            amount: amount,
            status: Status.Pending
        });
        transactionCounter++;

        emit TransactionDone(transactionCounter, msg.sender, receiver, amount);
    }
    
    function StatusAction(uint tId, Status newStatus) public{
        require(tId < transactionCounter, "Invalid Transaction ID");
        require(msg.sender == transactions[tId].sender, "Only sender can update status");
        require(transactions[tId].status == Status.Pending, "Transaction already finalized");

        require(newStatus == Status.Approved || newStatus == Status.Disputed, "Invalid Status transition");
        transactions[tId].status = newStatus;

        emit StatusUpdated(tId, newStatus);
    }

    address public disputeResolver;

    constructor() {
    disputeResolver = msg.sender;
    }

    function resolveDispute(uint tId, Status newStatus) public {
        require(msg.sender == disputeResolver, "Only dispute resolver can call this");
        require(transactions[tId].status == Status.Disputed, "Transaction is not disputed");

        require(newStatus == Status.Approved || newStatus == Status.Pending, "Invalid resolution");
        transactions[tId].status = newStatus;

        emit DisputeResolved(tId, newStatus);
    }


    function withdraw(uint tId)public{
        require(tId < transactionCounter, "Invalid Transaction ID");
        require(msg.sender == transactions[tId].receiver, "Only receiver can withdraw");
        require(transactions[tId].status == Status.Approved, "The transaction is not approved");

        uint256 amount = transactions[tId].amount;
        transactions[tId].amount = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit WithdrawalDone(tId, msg.sender, amount); 
    }
}