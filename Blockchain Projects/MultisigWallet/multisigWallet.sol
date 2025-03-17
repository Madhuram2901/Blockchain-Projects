// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultisigWallet{
    address[] public owners;
    uint public minNumofConfirmations;

    struct Transactions {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numofConfirmations;
    }

    Transactions[] public transactions;
    mapping (uint => mapping(address => bool)) public isConfirmed;

    constructor(address[] memory _owners, uint _minNumofConfirmations) {
        require(_owners.length > 0,"There should be atlest one owner");
        require(_owners.length >= _minNumofConfirmations, "Number of owner should be at least the min number of confirmations");

        for (uint i = 0; i<_owners.length; i++){
            owners.push(_owners[i]);
        }

        minNumofConfirmations = _minNumofConfirmations;
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public {
        transactions.push(
            Transactions({
            to: _to,
            value:_value,
            data: _data,
            executed: false,
            numofConfirmations: 0
            })
        );
    }

    function confirmTransaction(uint _txIndex) public {
        require(_txIndex < transactions.length, "Invalid transaction index");
        Transactions storage txn = transactions[_txIndex];

        require(!txn.executed, "Transaction already executed");
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");

        txn.numofConfirmations++;
        isConfirmed[_txIndex][msg.sender] = true;
    }


    function executeTransaction(uint _txIndex) public {
        require(_txIndex < transactions.length, "Invalid transaction index");
        Transactions storage txn = transactions[_txIndex];

        require(!txn.executed, "Transaction already executed");
        require(txn.numofConfirmations >= minNumofConfirmations, "Transaction not confirmed enough");

        txn.executed = true;

        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        require(success, "Transaction execution failed");
    }

    receive() external payable {}

}