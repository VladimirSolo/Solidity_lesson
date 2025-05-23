// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Deployer {
    /*
        This exercise assumes you know how to deploy a contract.

        1. Deploy `DeployMe` contract and return the address in `deployContract` function.
    */

    function deployContract() public returns (address) {
        DeployMe newContract = new DeployMe();
        return address(newContract);
    }
}

contract DeployMe {}
