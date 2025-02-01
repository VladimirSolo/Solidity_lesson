// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

/**
 * @title GasTracker - Triggers external calls to GasHandler
 * @notice This contract demonstrates how gas is tracked during external calls
 */
contract GasTracker {
    /**
     * @notice Triggers the processGasUsage function in GasHandler
     * @param handler The address of the GasHandler contract
     */
    function trigger(address handler) external {
        uint256 initialGas = gasleft(); // Store the amount of gas before the call

        GasHandler(payable(handler)).processGasUsage(msg.sender, initialGas); // External call to GasHandler
    }
}

/**
 * @title GasHandler - Handles authorization and gas-based ETH transfers
 * @notice Demonstrates a potential gas-related vulnerability during ETH transfers
 */
contract GasHandler {
    event GasUsed(uint256 gasUsed);

    mapping(address => bool) public authorized;

    /**
     * @notice Constructor initializes the deployer as an authorized address
     */
    constructor() {
        authorized[msg.sender] = true; // The contract creator is authorized by default
    }

    /**
     * @notice Sets authorization status for a specific address
     * @param addr The address to authorize or deauthorize
     * @param isAuthorized Boolean indicating authorization status
     */
    function setAuthorization(address addr, bool isAuthorized) external {
        require(authorized[msg.sender], "Not authorized");
        authorized[addr] = isAuthorized;
    }

    /**
     * @notice Allows the contract to receive ETH
     */
    receive() external payable {}

    /**
     * @notice Processes an ETH transfer based on gas usage
     * @dev Calculates used gas and attempts to send equivalent ETH to the receiver
     * @param receiver The address to receive ETH
     * @param initialGas The initial amount of gas before the external call
     */
    function processGasUsage(address receiver, uint256 initialGas) external {
        require(authorized[msg.sender], "Not authorized");

        uint256 currentGas = gasleft();
        uint256 gasUsed = initialGas - currentGas; // Calculate gas used

        // Attempt to send ETH based on the gas used
        (bool success, ) = receiver.call{value: gasUsed}("");
        require(success, "ETH transfer failed");

        emit GasUsed(gasUsed);
    }
}
