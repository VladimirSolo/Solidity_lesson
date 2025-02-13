// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract AnotherAuction {
    uint256 private constant DURATION = 1 days; // can set in constructor
    address payable public immutable seller;
    uint256 public immutable startingPrice;
    uint256 public immutable startAt;
    uint256 public immutable endsAt;
    uint256 public immutable discountRate;
    string public item;
    bool public stoped;

    constructor(
        uint256 _startingPrice,
        uint256 _discountRate,
        string memory _item
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        endsAt = block.timestamp + DURATION;
        require(
            startingPrice >= _discountRate * DURATION,
            "Starting price and discount is incorrect "
        );
        item = _item;
    }

    modifier notStoped() {
        require(!stoped, "Stoped");
        _;
    }

    function getPrice() public view notStoped returns (uint256) {
        uint256 timeElapsed = block.timestamp - startAt;
        uint256 discount = discountRate * timeElapsed;

        return startingPrice - discount;
    }

    function buy() external payable notStoped {
        require(block.timestamp < endsAt, "Ended");

        uint256 price = getPrice();
        require(msg.value >= price, "Not enough founds");

        uint256 refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        seller.transfer(address(this).balance);
        stoped = true;
    }
}
