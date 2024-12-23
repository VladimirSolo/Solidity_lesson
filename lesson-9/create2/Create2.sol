// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Create2
 * @dev  Contracts can be created by other contracts using the new keyword.
 *  Since 0.8.0, new keyword supports create2 feature by specifying salt options.
 */


contract MainContract {
  address public owner;
  event Deployed(address _thisAddress, uint _balance);

  constructor(address _owner) payable {
    owner = _owner;
    emit Deployed(address(this), getBalance());
  }

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }
}

/**
 * @title Create2
 * @dev This contract allows deploying instances of MainContract using the CREATE2 opcode for deterministic address generation.
 */
contract Create2 {
  event Deploy(address _newContract);

  /**
   * @dev Deploys a new instance of MainContract using the CREATE2 opcode.
   * @param _salt A unique value that affects the resulting contract address.
   * 
   * Requirements:
   * - The provided `_salt` must be unique for the desired address.
   * - `msg.value` will be forwarded to the deployed MainContract.
   */
  function deploy(uint _salt) external payable {
    MainContract newContract = new MainContract{
      salt: bytes32(_salt),
      value: msg.value
     }
     (msg.sender);
    emit Deploy(address(newContract));
  }

  /**
   * @dev Generates the bytecode for the MainContract with the specified owner.
   * @param _owner The address to set as the owner of the deployed MainContract.
   * @return The bytecode required to deploy the MainContract.
   */
  function getBytecode(address _owner) public pure returns(bytes memory) {
    bytes memory bytecode = type(MainContract).creationCode;
    return abi.encodePacked(bytecode, abi.encode(_owner));
  }

  /**
  * @dev Computes the deterministic address of a contract deployed using CREATE2.
  * @param bytecode The bytecode of the contract to deploy.
  * @param _salt The unique value used in the CREATE2 deployment.
  * @return The address at which the contract will be deployed.
  */
  function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
    // new_address = hash(0xFF, sender, salt, bytecode)
    bytes32 hash = keccak256(
        abi.encodePacked(
            bytes1(0xff),       // 0xFF, serving as a constant to avert collisions with CREATE.
            address(this),      // The sender’s address.
            _salt,              // A salt (32 bytes), an arbitrary value supplied by the sender.
            keccak256(bytecode) // The bytecode of the contract slated for deployment.
        )
      );
    return address(uint160(uint(hash)));
  }
}



/**
 * @title Create2
 * @dev https://solidity-by-example.org/new-contract/
 */

contract Car {
    address public owner;
    string public model;
    address public carAddr;

    constructor(address _owner, string memory _model) payable {
        owner = _owner;
        model = _model;
        carAddr = address(this);
    }
}

contract CarFactory {
    Car[] public cars;

    function create(address _owner, string memory _model) public {
        Car car = new Car(_owner, _model);
        cars.push(car);
    }

    function createAndSendEther(address _owner, string memory _model)
        public
        payable
    {
        Car car = (new Car){value: msg.value}(_owner, _model);
        cars.push(car);
    }

    function create2(address _owner, string memory _model, bytes32 _salt)
        public
    {
        Car car = (new Car){salt: _salt}(_owner, _model);
        cars.push(car);
    }

    function create2AndSendEther(
        address _owner,
        string memory _model,
        bytes32 _salt
    ) public payable {
        Car car = (new Car){value: msg.value, salt: _salt}(_owner, _model);
        cars.push(car);
    }

    function getCar(uint256 _index)
        public
        view
        returns (
            address owner,
            string memory model,
            address carAddr,
            uint256 balance
        )
    {
        Car car = cars[_index];

        return (car.owner(), car.model(), car.carAddr(), address(car).balance);
    }
}
