// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @dev keccak256 computes the Keccak-256 hash of the input.
 * Some use cases are:
 * Creating a deterministic unique ID from an input
 * Commit-Reveal scheme
 * Compact cryptographic signature (by signing the hash instead of a larger input)
 */

contract Keccak256Example {
    /**
     * @dev Generates a unique identifier for a transaction based on the provided parameters.
     * @param _sender The address of the sender.
     * @param _receiver The address of the receiver.
     * @param _amount The amount being transferred.
     * @param _nonce A unique number to ensure uniqueness of the transaction ID.
     * @return A `bytes32` hash representing the unique transaction ID.
     */
    function generateTransactionId(
        address _sender,
        address _receiver,
        uint256 _amount,
        uint256 _nonce
    ) public pure returns (bytes32) {
        // Hash the input data to create a unique ID
        return keccak256(abi.encodePacked(_sender, _receiver, _amount, _nonce));
    }

    /**
     * @dev Verifies the signature of a message to check if it was signed by the expected signer.
     * @param _signer The expected address of the signer.
     * @param _message The original message that was signed.
     * @param _v Recovery byte of the signature.
     * @param _r Half of the ECDSA signature pair.
     * @param _s Other half of the ECDSA signature pair.
     * @return `true` if the recovered signer matches the expected signer, otherwise `false`.
     */
    function verifySignature(
        address _signer,
        string memory _message,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public pure returns (bool) {
        // Hash the message
        bytes32 messageHash = keccak256(abi.encodePacked(_message));
        // Add Ethereum-specific prefix to the hash
        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );

        // Recover the signer address from the signature
        address recoveredSigner = ecrecover(ethSignedMessageHash, _v, _r, _s);

        // Check if the recovered signer matches the expected signer
        return recoveredSigner == _signer;
    }
}
