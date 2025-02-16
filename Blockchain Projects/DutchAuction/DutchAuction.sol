// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IERC721{
    function transferFrom(
        address _from,
        address _to,
        uint _nftId
    ) external;
}


contract DutchAuction{
    uint private constant DURATION = 7 days;
    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable StartingPrice;
    uint public immutable StartAt;
    uint public immutable ExpiresAt;
    uint public DiscountRate;

    constructor(
        uint _startingPrice,
        uint _DiscountRate,
        address _nft,
        uint _nftId
    ){
        seller = payable(msg.sender);
        StartingPrice = _startingPrice;
        StartAt = block.timestamp;
        ExpiresAt = block.timestamp + DURATION;
        DiscountRate = _DiscountRate;

        require(_startingPrice >= _DiscountRate * DURATION, "Starting Price < minimum price");
        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - StartAt;
        uint discount = DiscountRate * timeElapsed;
        return StartingPrice - discount;
    }

    function buy() external payable {
        require (block.timestamp < ExpiresAt, "Auction Expired");

        uint price = getPrice();

        require(msg.value >= price, " ETH < price");
    }
}