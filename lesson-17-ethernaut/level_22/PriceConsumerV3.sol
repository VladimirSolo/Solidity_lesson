// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* 
The integer math portion aside, getting prices or any sort of data from 
any single source is a massive attack vector in smart contracts.

You can clearly see from this example, that someone with a lot of capital could manipulate the price in one fell swoop,
and cause any applications relying on it to use the wrong price.

The exchange itself is decentralized, but the price of the asset is centralized,
since it comes from 1 dex. However, if we were to consider tokens that represent
actual assets rather than fictitious ones, most of them would have exchange pairs
in several dexes and networks. This would decrease the effect on the asset's price
in case a specific dex is targeted by an attack like this.

Oracles are used to get data into and out of smart contracts.

Chainlink Data Feeds (https://docs.chain.link/data-feeds/using-data-feeds)
 are a secure, reliable, way to get decentralized data into your smart contracts.
They have a vast library of many different sources, and also offer secure randomness, 
ability to make any API call, modular oracle network creation, upkeep, actions, and maintainance, and unlimited customization.

Uniswap TWAP Oracles (https://docs.uniswap.org/contracts/v2/concepts/core-concepts/oracles)
 relies on a time weighted price model called TWAP. While the design can be attractive,
this protocol heavily depends on the liquidity of the DEX protocol, and if this is too low, prices can be easily manipulated.

Here is an example of getting the price of Bitcoin in USD from a Chainlink data feed (on the Sepolia testnet):
 */

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */
    constructor() {
        priceFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }

    /**
     * Returns the latest price.
     */
    function getLatestPrice() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }
}
