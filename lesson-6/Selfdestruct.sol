// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Function
 * @notice  selfdestruct
 */

/** 
   * @notice
   * Solidity 0.8.24 Release Announcement
   * Posted by Solidity Team on January 26, 2024

   * EIP-6780 significantly curtails the functionality of the SELFDESTRUCT opcode.
   * In Cancun, the opcode will only perform an Ether transfer of the entire contract balance.
   * The account, including its storage and contract code, will no longer be cleared.
   * The only exception are cases in which destruction happens in the same transaction which deployed the contract.

   * The change does not require any support from the compiler.
   * It is a network-wide change that will affect all deployed contracts.
   * The --evm-version setting used when compiling the contract has no bearing on it.

   * Note that SELFDESTRUCT has already been deprecated for some time, by EIP-6049.
   * The deprecation is still in effect and the compiler will still emit warnings on its use.
   * Any use in newly deployed contracts is strongly discouraged even if the new behavior is taken into account.
   * Future changes to the EVM might further reduce the functionality of the opcode.
 */

contract Demo {
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}
