// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title ENS Registrator
 * @notice This contract is intended for registering domain names in the ENS system.
 * @dev This contract allows users to register domain names on the Ethereum Name Service (ENS) and manage ownership of registered domains.
 */

contract RegistratorENS {
    struct DomainInfo {
        address owner;
        uint creationTime; // --> uint256 === uint
        uint pricePaid;
    }

    mapping(string => DomainInfo) domains;
    address public owner;

    /**
     * @dev Constructor function that sets the contract owner to the deployer's address.
     * @dev Can add to specify an address in the constructor if it needed.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Registers a domain with the specified name and associates it with the sender's address and registration time.
     * @dev Not memory use calldata in constant form - saving gas.
     * @dev Use external instead of because it outside access.
     * @param domain The name of the domain to be registered.
     */
    function registerDomain(string calldata domain) external payable {
        // DomainInfo memory newDomain = DomainInfo({
        //     owner: msg.sender,
        //     creationTime: block.timestamp,
        //     pricePaid: msg.value
        // });

        // not good variant -->
        // newDomain.owner = msg.sender;
        // newDomain.creationTime = block.timestamp;
        // newDomain.pricePaid = msg.value;

        // best practice -->
        domains[domain] = DomainInfo({
            owner: msg.sender,
            creationTime: block.timestamp,
            pricePaid: msg.value
        });
    }

    /**
     * @dev Retrieves the owner of the specified domain.
     * @param domain The name of the domain to query.
     * @return The Ethereum address of the domain owner.
     */
    function getDomainOwner(
        string calldata domain // --> beeter then public
    ) external view returns (address) {
        return domains[domain].owner;
    }

    /**
     * @dev Allows the contract owner to withdraw funds from the contract.
     * @param recipient The Ethereum address to receive the withdrawn funds.
     * @param amount The amount of funds to withdraw.
     */
    function withdrawFunds(address payable recipient, uint256 amount) external {
        // TODO: anyone can withdraw mone - need owner verification
        recipient.transfer(amount);
    }
}
