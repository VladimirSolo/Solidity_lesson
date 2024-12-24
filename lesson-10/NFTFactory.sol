// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title NFT
 * @dev This contract represents a simple NFT with a unique ID, owner, and metadata URI.
 */
contract NFT {
    address public owner;  // Address of the NFT owner
    uint256 public tokenId; // Unique token ID
    string public metadataURI; // URI pointing to the metadata of the token

    /**
     * @dev Constructor that initializes the NFT with the owner's address, token ID, and metadata URI.
     * @param _owner The address of the NFT owner
     * @param _tokenId The unique token ID
     * @param _metadataURI The metadata URI of the token
     */
    constructor(address _owner, uint256 _tokenId, string memory _metadataURI) payable {
        owner = _owner;
        tokenId = _tokenId;
        metadataURI = _metadataURI;
    }
}

/**
 * @title NFTFactory
 * @dev This contract acts as a factory to create new NFT contracts.
 * It also supports creating NFTs with ether and using the `create2` feature for deterministic contract addresses.
 */
contract NFTFactory {
    NFT[] public nfts;  // Array to store created NFTs

    /**
     * @dev Creates a new NFT contract and stores it in the `nfts` array.
     * @param _owner The address of the NFT owner
     * @param _tokenId The unique token ID
     * @param _metadataURI The metadata URI of the token
     */
    function create(address _owner, uint256 _tokenId, string memory _metadataURI) public {
        NFT nft = new NFT(_owner, _tokenId, _metadataURI);  // Create a new NFT
        nfts.push(nft);  // Add the created NFT to the array
    }

    /**
     * @dev Creates a new NFT contract and sends ether to the contract.
     * This function allows creating an NFT with ether.
     * @param _owner The address of the NFT owner
     * @param _tokenId The unique token ID
     * @param _metadataURI The metadata URI of the token
     */
    function createAndSendEther(address _owner, uint256 _tokenId, string memory _metadataURI)
        public
        payable
    {
        NFT nft = (new NFT){value: msg.value}(_owner, _tokenId, _metadataURI);  // Create a new NFT with ether
        nfts.push(nft);  // Add the created NFT to the array
    }

    /**
     * @dev Creates a new NFT contract using the `create2` method.
     * The `create2` allows creating a contract with a deterministic address based on a salt.
     * @param _owner The address of the NFT owner
     * @param _tokenId The unique token ID
     * @param _metadataURI The metadata URI of the token
     * @param _salt A value used to generate the contract address deterministically
     */
    function create2(address _owner, uint256 _tokenId, string memory _metadataURI, bytes32 _salt)
        public
    {
        NFT nft = (new NFT){salt: _salt}(_owner, _tokenId, _metadataURI);  // Create a new NFT with the provided salt
        nfts.push(nft);  // Add the created NFT to the array
    }

    /**
     * @dev Creates a new NFT contract with ether and uses the `create2` method.
     * The `create2` allows creating a contract with a deterministic address based on a salt.
     * @param _owner The address of the NFT owner
     * @param _tokenId The unique token ID
     * @param _metadataURI The metadata URI of the token
     * @param _salt A value used to generate the contract address deterministically
     */
    function create2AndSendEther(
        address _owner,
        uint256 _tokenId,
        string memory _metadataURI,
        bytes32 _salt
    ) public payable {
        NFT nft = (new NFT){value: msg.value, salt: _salt}(_owner, _tokenId, _metadataURI);  // Create a new NFT with ether and salt
        nfts.push(nft);  // Add the created NFT to the array
    }

    /**
     * @dev Retrieves information about a specific NFT contract from the `nfts` array.
     * @param _index The index of the NFT in the `nfts` array
     * @return owner The address of the NFT owner
     * @return tokenId The unique token ID
     * @return metadataURI The metadata URI of the token
     * @return balance The balance of ether in the NFT contract
     */
    function getNFT(uint256 _index)
        public
        view
        returns (
            address owner,
            uint256 tokenId,
            string memory metadataURI,
            uint256 balance
        )
    {
        NFT nft = nfts[_index];  // Retrieve the NFT at the specified index

        return (nft.owner(), nft.tokenId(), nft.metadataURI(), address(nft).balance);  // Return NFT details
    }
}
