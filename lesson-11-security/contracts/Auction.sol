// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// If funds are sent first and then the balance is updated, that's a vulnerability!!!

contract Auction {
    mapping(address bidder => uint) public bids;

    function bid() external payable {
        bids[msg.sender] += msg.value;
    }

    // Bad pracktice test will be okey
    function refund() external {
        uint refundAmount = bids[msg.sender];

        if (refundAmount > 0) {
            bids[msg.sender] = 0;
            (bool ok, ) = msg.sender.call{value: refundAmount}(""); // go to receive in hack
            require(ok, "can't send");

            // bids[msg.sender] = 0; // NOT DO THIS!!!!
            // bids[msg.sender] -= refundAmount; // test will error!!

            // unchecked {
            //     bids[msg.sender] -= refundAmount;  // NOT DO THIS!!!!
            // }
        }
    }
}

contract Hack {
    Auction toHack;
    uint constant BID_AMOUNT = 1 ether;

    constructor(address _toHack) payable {
        require(msg.value == BID_AMOUNT);

        toHack = Auction(_toHack);
        toHack.bid{value: msg.value}();
    }

    function hack() public {
        toHack.refund();
    }

    receive() external payable {
        if (address(toHack).balance >= BID_AMOUNT) {
            hack();
        }
    }
}

/**
 * @title ReEntrancy
 * @dev Ensure all state changes happen before calling external contracts
 *       Use function modifiers that prevent re-entrancy
 */
contract ReEntrancy {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}
