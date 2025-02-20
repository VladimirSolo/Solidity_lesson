// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Ownable.sol";

contract MultiSignature is Ownable {
    uint public requiredApprovals;
    struct Transaction {
        address _to;
        uint _value;
        bytes _data;
        bool _executed;
    }
    Transaction[] public transactions;
    mapping(uint => uint) public approvalsCount;
    mapping(uint => mapping(address => bool)) public approved;

    event Deposit(address _from, uint _amount);
    event Submit(uint _txId);
    event Approve(address _owner, uint _txId);
    event Revoke(address _owner, uint _txId);
    event Executed(uint _txId);

    constructor(
        address[] memory _owners,
        uint _requiredApprovals
    ) Ownable(_owners) {
        require(
            _requiredApprovals > 0 && _requiredApprovals <= _owners.length,
            "Invalid approvals count"
        );

        requiredApprovals = _requiredApprovals;
    }

    function submit(
        address _to,
        uint _value,
        bytes calldata _data
    ) external onlyOwners {
        Transaction memory newTx = Transaction({
            _to: _to,
            _value: _value,
            _data: _data,
            _executed: false
        });

        transactions.push(newTx);
        emit Submit(transactions.length - 1);
    }

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    function encode(
        string memory _fn,
        string memory _arg
    ) public pure returns (bytes memory) {
        return abi.encodeWithSignature(_fn, _arg);
    }

    modifier txExists(uint _txId) {
        require(_txId < transactions.length, "Tx does not exist!");
        _;
    }

    modifier noApproved(uint _txId) {
        require(!isApproved(_txId, msg.sender), "Tx already approved!");
        _;
    }

    function isApproved(
        uint _txId,
        address _address
    ) private view returns (bool) {
        return approved[_txId][_address];
    }

    modifier notExucuted(uint _txId) {
        require(!transactions[_txId]._executed, "Tx already executed!");
        _;
    }

    modifier wasApproved(uint _txId) {
        require(!isApproved(_txId, msg.sender), "Not yet approved!");
        _;
    }

    function approve(
        uint _txId
    ) external onlyOwners txExists(_txId) noApproved(_txId) notExucuted(_txId) {
        approved[_txId][msg.sender] = true;
        approvalsCount[_txId] += 1;
        emit Approve(msg.sender, _txId);
    }

    function revoke(
        uint _txId
    )
        external
        onlyOwners
        txExists(_txId)
        notExucuted(_txId)
        wasApproved(_txId)
    {
        approved[_txId][msg.sender] = false;
        approvalsCount[_txId] -= 1;
        emit Revoke(msg.sender, _txId);
    }

    modifier enoughApprovals(uint _txId) {
        require(
            approvalsCount[_txId] >= requiredApprovals,
            "Not enough approvals!"
        );
        _;
    }

    function execute(
        uint _txId
    ) external txExists(_txId) notExucuted(_txId) enoughApprovals(_txId) {
        Transaction storage transaction = transactions[_txId];

        (bool success, ) = transaction._to.call{value: transaction._value}(
            transaction._data
        );
        require(success, "Transaction failed!");

        transaction._executed = true;
        emit Executed(_txId);
    }

    receive() external payable {
        deposit();
    }
}

contract Receiver {
    string public message;

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getMoney(string memory _msg) external payable {
        message = _msg;
    }
}
