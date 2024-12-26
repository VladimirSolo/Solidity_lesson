// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title BaseRecord
 * @dev Abstract contract providing common functionality for record-based contracts.
 *      Stores the creation timestamp and a string identifier for the record type.
 *      Designed to be inherited by contracts handling specific types of records,
 *      such as string or address records.
 */
abstract contract BaseRecord {
    uint public timeOfCreation; // Timestamp of record creation
    string public recordType;   // Type of the record ("String", "Address", etc.)

    /**
     * @dev Constructor to initialize the creation time and record type.
     * @param _recordType A string indicating the type of the record (e.g., "String" or "Address").
     */
    constructor(string memory _recordType) {
        timeOfCreation = block.timestamp; // Set the creation time to the current block timestamp
        recordType = _recordType;         // Assign the provided record type
    }
}

/**
 * @title StringRecord
 * @dev A contract to store and manage a string record. 
 *      Includes functionality to initialize, update, and retrieve the record.
 */
contract StringRecord is BaseRecord {
    string public record;

   /**
     * @dev Constructor to initialize the `StringRecord` contract with a given string.
     * @param _record The initial string value for the record.
     */
    constructor(string memory _record) BaseRecord("String") {
        record = _record;
    }

    /**
     * @dev Returns the current string record.
     * @return The string value of the record.
     */
    function getRecordType() public view returns (string memory) {
        return record;
    }

    /**
     * @dev Updates the string record with a new value.
     * @param _record The new string value to set.
     */
    function setRecordType(string calldata _record) public {
        record = _record;
    }
}

/**
 * @title AddressRecord
 * @dev A contract to store and manage an address record. 
 *      Includes functionality to initialize, update, and retrieve the record.
 */
contract AddressRecord is BaseRecord {
    address public record;

    /**
     * @dev Constructor to initialize the `AddressRecord` contract with a given address.
     * @param _record The initial address value for the record.
     */
    constructor(address _record) BaseRecord("Address") {
        record = _record;
    }

    /**
     * @dev Returns the current address record.
     * @return The address value of the record.
     */
    function getRecordType() public view returns (address) {
        return record;
    }

    /**
     * @dev Updates the address record with a new value.
     * @param _record The new address value to set.
     */
    function setRecordType(address _record) public {
        record = _record;
    }
}

/**
 * @title RecordFactory
 * @dev A factory contract to create and manage multiple `StringRecord` and `AddressRecord` contracts.
 *      Tracks all created records and allows retrieval of their details.
 */
contract RecordFactory {
    struct Record {
        address recordAddress;
        string recordType;
    }

    Record[] public records;

    /**
     * @dev Emitted when a new record is created.
     * @param recordAddress The address of the created record contract.
     * @param recordType The type of the record ("String" or "Address").
     */
    event RecordCreated(address indexed recordAddress, string recordType);

    /**
     * @dev Creates a new `StringRecord` contract and stores its address in the factory.
     * @param _record The initial string value for the `StringRecord`.
     */
    function addRecord(string memory _record) public {
        StringRecord stringRecord = new StringRecord(_record);
        records.push(Record(address(stringRecord), "String"));
        emit RecordCreated(address(stringRecord), "String");
    }

    /**
     * @dev Creates a new `AddressRecord` contract and stores its address in the factory.
     * @param _record The initial address value for the `AddressRecord`.
     */
    function addRecord(address _record) public {
        AddressRecord addressRecord = new AddressRecord(_record);
        records.push(Record(address(addressRecord), "Address"));
        emit RecordCreated(address(addressRecord), "Address");
    }

    /**
     * @dev Returns all records created by the factory.
     * @return An array of `Record` structs, each containing the address and type of the record.
     */
    function getAllRecords() public view returns (Record[] memory) {
        return records;
    }
}
