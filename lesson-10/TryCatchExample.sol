// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// External contract for try/catch demonstration
contract ExternalContract {
    /**
     * @dev Performs a simple operation and returns a success message.
     * @param value The input parameter, which must be greater than 0.
     * @return A string message "Operation succeeded" if the operation is successful.
     */
    function doSomething(uint256 value) public pure returns (string memory) {
        require(value > 0, "Value must be greater than zero");
        return "Operation succeeded";
    }

    /**
     * @dev Constructor that can fail intentionally based on the input.
     * @param shouldFail If true, the constructor will revert with an error.
     */
    constructor(bool shouldFail) {
        require(!shouldFail, "Constructor failed intentionally");
    }
}

// Main contract
contract TryCatchExample {
    event Success(string message);
    event Failure(string reason);
    event BytesFailure(bytes reason);

    ExternalContract public externalContract;

    /**
     * @dev Deploys the main contract and initializes an instance of ExternalContract.
     */
    constructor() {
        externalContract = new ExternalContract(false);
    }

    /**
     * @dev Demonstrates try/catch with an external contract function call.
     * Emits `Success` on successful execution, or `Failure`/`BytesFailure` if an error occurs.
     * @param value The input value to be passed to the external contract function.
     */
    function tryCatchExternal(uint256 value) public {
        try externalContract.doSomething(value) returns (string memory result) {
            emit Success(result);
        } catch Error(string memory reason) {
            emit Failure(reason); // Catches require or revert errors
        } catch (bytes memory reason) {
            emit BytesFailure(reason); // Catches assert errors
        }
    }

    /**
     * @dev Demonstrates try/catch with contract creation.
     * Emits `Success` if the contract is created successfully, or `Failure`/`BytesFailure` if an error occurs.
     * @param shouldFail If true, the constructor of the new contract will intentionally fail.
     */
    function tryCatchContractCreation(bool shouldFail) public {
        try new ExternalContract(shouldFail) returns (ExternalContract newContract) {
            emit Success("Contract created successfully");
        } catch Error(string memory reason) {
            emit Failure(reason); // Catches require or revert errors
        } catch (bytes memory reason) {
            emit BytesFailure(reason); // Catches assert errors
        }
    }
}
