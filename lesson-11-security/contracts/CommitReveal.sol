// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

/*
  A commitment scheme is a cryptographic algorithm used to allow someone
  to commit to a value while keeping it hidden from others with the ability
  to reveal it later. The values in a commitment scheme are binding,
  meaning that no one can change them once committed.
  The scheme has two phases: a commit phase in which a value is chosen and specified,
  and a reveal phase in which the value is revealed and checked.
  https://medium.com/@0xkaden/exploring-commit-reveal-schemes-on-ethereum-c4ff5a777db8
*/

contract CommitReveal {
    uint256 public secretNumber;
    bytes32 public hashedSecretNumber;

    constructor(bytes32 _hashedSecretNumber) {
        hashedSecretNumber = _hashedSecretNumber;
    }

    function reveal(uint _secretNumber, bytes32 _salt) external {
        bytes32 commit = keccak256(
            abi.encodePacked(msg.sender, _secretNumber, _salt)
        );

        require(commit == hashedSecretNumber, "invalid reveal!");

        secretNumber = _secretNumber;
    }
}
