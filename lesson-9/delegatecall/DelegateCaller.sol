// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//if not access to MainContract can use interface
// interface IMainContract {
//      function pay() external  payable;
// }

/**
 * @title delegatecall
 * @dev
 * delegatecall is a low level function similar to call.
 * When contract DelegateCaller executes delegatecall to contract MainContract, MainContract's code is executed
 * with contract DelegateCaller's storage, msg.sender and msg.value.
 */

contract DelegateCaller {
    // storage layout must be the same as contract MainContract
    address public sender;
    uint public amount;

    function getBalance() public view returns(uint) {
      return address(this).balance;
    }

  function callPay(address _contact) external  payable {
          (bool result,) = _contact.delegatecall(
          abi.encodeWithSignature(
              "pay()"
          )
          // abi.encodeWithSelector(
          //   IMainContract.pay.selector
          // )
      );

      require(result, "failed");
  }
} 