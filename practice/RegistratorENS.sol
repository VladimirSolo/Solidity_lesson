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
        uint registrationYears;
    }

    mapping(string => DomainInfo) domains;
    address public owner;
    uint public pricePerYear = 0.01 ether;
    uint public renewalCoefficient = 90;

    /**
     * @dev Constructor function that sets the contract owner to the deployer's address.
     * @dev Can add to specify an address in the constructor if it needed.
     */
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner!");
        _;
    }

    function setAmount(uint _amount) external onlyOwner {
        pricePerYear = _amount;
    }

    /**
     * @dev Registers a domain with the specified name and associates it with the sender's address and registration time.
     * @dev Not memory use calldata in constant form - saving gas.
     * @dev Use external instead of because it outside access.
     * @dev Ensures the domain is available and calculates the required payment.
     * @dev Stores the domain information, including the owner, registration time, and duration.
     * @param domain The name of the domain to be registered.
     * @param period The number of years to register the domain (must be between 1 and 10).
     */
    function registerDomain(string calldata domain, uint period) external payable {
        // DomainInfo memory newDomain = DomainInfo({
        //     owner: msg.sender,
        //     creationTime: block.timestamp,
        //     pricePaid: msg.value
        // });

        // not good variant -->
        // newDomain.owner = msg.sender;
        // newDomain.creationTime = block.timestamp;
        // newDomain.pricePaid = msg.value;

        // check period -> set 1-10
        require(period >= 1 && period <= 10, "Registration period must be between 1 and 10 years");

        // calculating the cost of registration
        uint payment = period * pricePerYear;
        require(msg.value >= payment, "Insufficient payment");

        // check that domain is free
        DomainInfo storage existingDomain = domains[domain];
        require(
            existingDomain.owner == address(0) || 
            block.timestamp > existingDomain.creationTime + existingDomain.registrationYears * 365 days,
            "Domain is already registered"
        );

        // best practice -->
        domains[domain] = DomainInfo({
            owner: msg.sender,
            creationTime: block.timestamp,
            pricePaid: msg.value,
            registrationYears: period
        });
    }

    /**
     * @dev Retrieves the owner of the specified domain.
     * @param domain The name of the domain to query.
     * @return The Ethereum address of the domain owner.
     */
    function getDomainOwner(
        string calldata domain 
    ) external view returns (address) { // --> beeter then public
        return domains[domain].owner;
    }

    /**
     * @dev Allows the contract owner to withdraw funds from the contract.
     * @param recipient The Ethereum address to receive the withdrawn funds.
     * @param amount The amount of funds to withdraw.
     */
    function withdrawFunds(address payable recipient, uint256 amount) external onlyOwner {
        recipient.transfer(amount);
    }

    /**
     * @dev Renews the registration of an existing domain for a specified number of years.
     * Verifies that the caller is the current owner of the domain and calculates the renewal cost.
     * Updates the registration period of the domain.
     * @param domain The name of the domain to be renewed.
     * @param period The number of years to extend the domain registration (must be between 1 and 10).
     */
    function renewalDomain(string calldata domain, uint period) external payable {
        // check period
        require(period >= 1 && period <= 10, "Renewal period must be between 1 and 10 years");

        DomainInfo storage existingDomain = domains[domain];
        // check owner
        require(existingDomain.owner == msg.sender, "Only the owner can renew the domain");

        // calculate price
        uint renewalPricePerYear = (pricePerYear * renewalCoefficient) / 100;
        uint payment = period * renewalPricePerYear;
        // check payment
        require(msg.value >= payment, "Insufficient payment for renewal");

        // renewal registration
        existingDomain.registrationYears += period;
    }
}
