// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RecordsStorage is Ownable {
    struct Record {
        address recordAddress;
        string recordType;
    }

    Record[] public records;
    mapping(address => bool) public factories;

    event RecordAdded(address indexed recordAddress, string recordType);

    modifier onlyFactory() {
        require(factories[msg.sender], "RecordsStorage: Not an authorized factory");
        _;
    }

    constructor(address initialOwner) Ownable(initialOwner) {}

    function addRecord(address _recordAddress, string memory _recordType) public onlyFactory {
        records.push(Record(_recordAddress, _recordType));
        emit RecordAdded(_recordAddress, _recordType);
    }

    function addFactory(address factoryAddress) public onlyOwner {
        factories[factoryAddress] = true;
    }

    function getAllRecords() public view returns (Record[] memory) {
        return records;
    }
}

abstract contract BaseRecordFactory {
    address public recordsStorageAddress;

    constructor(address _recordsStorageAddress) {
        require(_recordsStorageAddress != address(0), "Invalid records storage address");
        recordsStorageAddress = _recordsStorageAddress;
    }

    function onRecordAdding(address recordAddress, string memory recordType) internal {
        (bool success, ) = recordsStorageAddress.call(
            abi.encodeWithSignature("addRecord(address,string)", recordAddress, recordType)
        );
        require(success, "Failed to add record");
    }

    function addRecord(string memory data) public virtual;
}

contract StringRecordFactory is BaseRecordFactory {
    constructor(address _recordsStorageAddress) BaseRecordFactory(_recordsStorageAddress) {}

    function addRecord(string memory _data) public override {
        StringRecord stringRecord = new StringRecord(_data);
        onRecordAdding(address(stringRecord), "String");
    }
}

contract EnsRecordFactory is BaseRecordFactory {
    constructor(address _recordsStorageAddress) BaseRecordFactory(_recordsStorageAddress) {}

    function addRecord(string memory data) public override {
        (string memory _domain, address _owner) = abi.decode(bytes(data), (string, address));
        EnsRecord ensRecord = new EnsRecord(_domain, _owner);
        onRecordAdding(address(ensRecord), "ens");
    }
}

contract AddressRecordFactory is BaseRecordFactory {
    constructor(address _recordsStorageAddress) BaseRecordFactory(_recordsStorageAddress) {}

    function addRecord(string memory data) public override {
        address _record = abi.decode(bytes(data), (address));
        AddressRecord addressRecord = new AddressRecord(_record);
        onRecordAdding(address(addressRecord), "Address");
    }
}