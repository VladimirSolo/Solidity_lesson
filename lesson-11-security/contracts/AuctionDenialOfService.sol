// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract AuctionDenialOfService {
    mapping(address bidder => uint) public bids;
    address[] public bidders;

    function bid() external payable {
        bids[msg.sender] += msg.value;
        bidders.push(msg.sender);
    }

    // pattern push and Out-of-Gas,  DOS -> Denial of Service!!
    function refund() external {
        for (uint i = 0; i < bidders.length; ++i) {
            address currentBidder = bidders[i];

            uint refundAmount = bids[currentBidder];

            bids[currentBidder] = 0;

            if (refundAmount > 0) {
                (bool ok, ) = currentBidder.call{value: refundAmount}("");
                // require(ok, "can't send");

                if (!ok) {
                    // can log but also
                    bids[currentBidder] = refundAmount;
                }
            }
        }
    }

    //  Need using pull-over-push (withdraw())
    function withdraw() external {
        uint256 amount = bids[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        bids[msg.sender] = 0; // Zero balance before transfer !!!

        (bool sent, ) = payable(msg.sender).call{value: amount}(""); // The user takes the money himself!
        require(sent, "Failed to send Ether");
    }
}

contract HackAttack {
    AuctionDenialOfService toHack;
    uint constant BID_AMOUNT = 100;

    constructor(address _toHack) payable {
        require(msg.value == BID_AMOUNT);

        toHack = AuctionDenialOfService(_toHack);
        toHack.bid{value: msg.value}();
    }
}
