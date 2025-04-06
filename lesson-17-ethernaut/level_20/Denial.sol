// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint256 timeLastWithdrawn;
    mapping(address => uint256) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint256 amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

/* 
This level demonstrates that external calls to unknown contracts 
can still create denial of service attack vectors if a fixed amount of gas is not specified.

If you are using a low level call to continue executing in the event
 an external call reverts, ensure that you specify a fixed gas stipend. 

https://docs.soliditylang.org/en/latest/security-considerations.html#use-the-checks-effects-interactions-pattern

 Note: An external CALL can use at most 63/64 of the gas currently available at
  the time of the CALL. Thus, depending on how much gas is required to complete a transaction,
   a transaction of sufficiently high gas (i.e. one such that
  1/64 of the gas is capable of completing the remaining opcodes 
  in the parent call) can be used to mitigate this particular attack.
 */
