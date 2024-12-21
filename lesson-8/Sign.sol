// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Sign
 * @notice  
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
 */
 
contract Sign {
  function verify(address _signer, string memory _message, bytes memory _sig) external pure returns(bool) {
    // hash
    bytes32 msgHash = messageHash(_message);
    /*
      hash with string "\x19Ethereum Signed Message:\n32"
      encode(message : 𝔹⁸ⁿ) = "\x19Ethereum Signed Message:\n" ‖ len(message) ‖ message where len(message)
      is the non-zero-padded ascii-decimal encoding of the number of bytes in message.
    */
    bytes32 signedMshHash = ehtSignedMsgHash(msgHash);
    //call recover
    return recover(signedMshHash, _sig) == _signer;
  }

  function messageHash(string memory _msg) public pure returns(bytes32) {
    return keccak256(abi.encodePacked(_msg));
  }

  function ehtSignedMsgHash(bytes32 _msgHash) public pure returns(bytes32) {
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _msgHash));
  }

/**
 * @dev
 * recover the address associated with the public key from elliptic curve signature or return zero on error.
 * The function parameters correspond to ECDSA values of the signature:
 * r = first 32 bytes of signature
 * s = second 32 bytes of signature
 * v = final 1 byte of signature
 * ecrecover returns an address, and not an address payable. 
 * https://docs.soliditylang.org/en/latest/units-and-global-variables.html 
 */

  function recover(bytes32 _ethSignedMsgHash, bytes memory _sig) public pure returns(address) {
    (bytes32 r, bytes32 s, uint8 v) = _splitSig(_sig);
    return ecrecover(_ethSignedMsgHash, v, r, s);
  }

  function _splitSig(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v) { // 65 bytes
    require(_sig.length == 65, "invalid signature");

    assembly {
      r := mload(add(_sig, 32))
      s := mload(add(_sig, 64))
      v := byte(0, mload(add(_sig, 96)))
    }
  }
}