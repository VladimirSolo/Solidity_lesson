// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract TimeLock {
    address public owner;
    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 100;
    uint public constant EXPIRE_DELAY = 1000;

    mapping(bytes32 => bool) public queuedTxs;

    event Queued(
        bytes32 indexed txId,
        address indexed to,
        uint value,
        string fn,
        bytes data,
        uint timestamp
    );

    event Exucuted(
        bytes32 indexed txId,
        address indexed to,
        uint value,
        string fn,
        bytes data,
        uint timestamp
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner!");
        _;
    }

    function queue(
        address _to,
        uint _value,
        string calldata _fn,
        bytes calldata _data,
        uint _timestamp
    ) external onlyOwner returns (bytes32) {
        bytes32 txId = keccak256(
            abi.encode(_to, _value, _fn, _data, _timestamp)
        );

        require(!queuedTxs[txId], "Already queued!");

        require(
            _timestamp >= block.timestamp + MIN_DELAY &&
                _timestamp <= block.timestamp + MAX_DELAY
        );

        queuedTxs[txId] = true;

        emit Queued(txId, _to, _value, _fn, _data, _timestamp);

        return txId;
    }

    function exucute(
        address _to,
        uint _value,
        string calldata _fn,
        bytes calldata _data,
        uint _timestamp
    ) external payable onlyOwner returns (bytes memory) {
        bytes32 txId = keccak256(
            abi.encode(_to, _value, _fn, _data, _timestamp)
        );

        require(queuedTxs[txId], "Not queued!");
        require(block.timestamp >= _timestamp, "Too early!");
        require(block.timestamp >= _timestamp + EXPIRE_DELAY, "Too late!");

        delete queuedTxs[txId];

        bytes memory data;
        if (bytes(_fn).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_fn))), _data);
        } else {
            data = _data;
        }

        (bool success, bytes memory resp) = _to.call{value: _value}(data);

        require(success, "Tx failed!");

        emit Exucuted(txId, _to, _value, _fn, _data, _timestamp);

        return resp;
    }

    function cancel(bytes32 _txId) external onlyOwner {
        require(queuedTxs[_txId], "Not queued!");

        delete queuedTxs[_txId];
    }
}

contract Runner {
    address public lock;
    string public message;
    mapping(address => uint) public payments;

    constructor(address _lock) {
        lock = _lock;
    }

    function run(string memory newMsg) external payable {
        require(msg.sender == lock, "Invalid address!");

        payments[msg.sender] += msg.value;
        message = newMsg;
    }

    function newTimestamp() external view returns (uint) {
        return block.timestamp + 20;
    }

    function prepareData(
        string calldata _msg
    ) external pure returns (bytes memory) {
        return abi.encode(_msg);
    }
}
