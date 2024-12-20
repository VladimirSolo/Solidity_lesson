// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./SharedWallet.sol";

contract Wallet is SharedWallet {
    event MoneyWithdrawn(address indexed _to, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function getBalance() public  view returns(uint) {
        return address(this).balance;
    }

    function withdrawMoney(uint _amount) external ownerOrWithinLimitOrAdmin(_amount) {
        require(_amount <= getBalance(), "Not enough money");
        
        if(!isOwner()) {
            deduceFromLimit(msg.sender, _amount);
        }
        
        payable(msg.sender).transfer(_amount);

        emit MoneyWithdrawn(msg.sender, _amount);
    }

    fallback() external payable { }

    receive() external payable { 
        emit MoneyReceived(msg.sender, msg.value);
    }
} 