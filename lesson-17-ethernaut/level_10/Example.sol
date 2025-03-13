// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// https://docs.soliditylang.org/en/v0.5.11/security-considerations.html#re-entrancy

// THIS CONTRACT CONTAINS A BUG - DO NOT USE
contract Fund1 {
    /// Mapping of ether shares of the contract.
    mapping(address => uint) shares;

    /// Withdraw your share.
    function withdraw() public {
        if (msg.sender.send(shares[msg.sender])) shares[msg.sender] = 0;
    }
}

contract Fund2 {
    /// Mapping of ether shares of the contract.
    mapping(address => uint) shares;

    /// Withdraw your share.
    function withdraw() public {
        (bool success, ) = msg.sender.call.value(shares[msg.sender])("");
        if (success) shares[msg.sender] = 0;
    }
}

/* 
To avoid re-entrancy, you can use the Checks-Effects-Interactions pattern as outlined further below:
 */

contract Fund {
    /// Mapping of ether shares of the contract.
    mapping(address => uint) shares;

    /// Withdraw your share.
    function withdraw() public {
        uint share = shares[msg.sender];
        shares[msg.sender] = 0;
        msg.sender.transfer(share);
    }
}

/* 
Another approach to preventing reentrancy is to explicitly check for and reject such calls.
 Here’s a simple version of a reentrancy guard so you can see the idea:
 */

// https://diligence.consensys.io/blog/2019/09/stop-using-soliditys-transfer-now/

contract Guarded {
    bool locked = false;

    function withdraw() external {
        require(!locked, "Reentrant call detected!");
        locked = true;
        // ...
        locked = false;
    }
}
