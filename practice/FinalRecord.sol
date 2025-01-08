    // SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Record {
    uint256 public timeOfCreation;

    constructor() {
        timeOfCreation = block.timestamp;
    }

    function getRecordType() public pure virtual returns (string memory);
}

contract StringRecord is Record {
    string public record;

    constructor(string memory _record) {
        record = _record;
    }

    function getRecordType() public pure override returns (string memory) {
        return "string";
    }

    function setRecord(string memory _record) public {
        record = _record;
    }
}

contract AddressRecord is Record {
    address public record;

    constructor(address _record) {
        record = _record;
    }

    function getRecordType() public pure override returns (string memory) {
        return "address";
    }

    function setRecord(address _record) public {
        record = _record;
    }
}

contract EnsRecord is Record {
    string public domain;
    address public owner;

    constructor(string memory _domain) {
        domain = _domain;
    }

    function getRecordType() public pure override returns (string memory) {
        return "ens";
    }

    function setDomain(string memory _domain) public {
        domain = _domain;
    }

    function setOwner(address _owner) public {
        owner = _owner;
    }
}

interface IRecordAddable {
    function addRecord(Record record) external;
}

abstract contract RecordFactory {
    RecordsStorage recordAddable;

    constructor(RecordsStorage _recordAddable) {
        recordAddable = _recordAddable;
    }

    function onRecordAdding(Record record) internal {
        recordAddable.addRecord(record);
    }
}

contract AddressRecordFactory is RecordFactory {
    constructor(RecordsStorage _recordAddable) RecordFactory(_recordAddable) {}

    function addAddressRecord(address _record) public {
        AddressRecord addressRecord = new AddressRecord(_record);
        onRecordAdding(addressRecord);
    }
}

contract StringRecordFactory is RecordFactory {
    constructor(RecordsStorage _recordAddable) RecordFactory(_recordAddable) {}

    function addStringRecord(string memory _record) public {
        StringRecord stringRecord = new StringRecord(_record);
        onRecordAdding(stringRecord);
    }
}

contract EnsRecordFactory is RecordFactory {
    constructor(RecordsStorage _recordAddable) RecordFactory(_recordAddable) {}

    function addEnsRecord(string memory _record) public {
        EnsRecord ensRecord = new EnsRecord(_record);
        onRecordAdding(ensRecord);
    }
}

contract RecordsStorage is IRecordAddable, Ownable {
    Record[] public recordsStorage;

    mapping(RecordFactory => bool) private factories;
    
    function addRecord(Record record) external override {
        require(factories[RecordFactory(msg.sender)], "Not allowed!");
        recordsStorage.push(record);
    }

    function addFactory(RecordFactory _recordFactory) public onlyOwner {
        factories[_recordFactory] = true;
    }
}
