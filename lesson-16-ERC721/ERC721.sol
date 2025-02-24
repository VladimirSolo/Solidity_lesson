// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IERC721.sol";
import "./IERC721MetaData.sol";
import "./Strings.sol";
import "./IERC721Receiver.sol";
import "./ERC165.sol";

contract ERC721 is IERC721, IERC721Metadata, ERC165 {
    using Strings for uint;

    string private _name;
    string private _symbol;

    mapping(address => uint) private _balances;
    mapping(uint => address) private _owners;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorsApprovals;

    modifier _requireMinted(uint tokenId) {
        require(_exists(tokenId), "Not Minted!");
        _;
    }

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Not approved or not Owner!"
        );

        _tranfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not an Owner!");
        _safeTransfer(from, to, tokenId, data);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        require(owner != address(0), "Owner not zero");

        return _balances[owner];
    }

    function ownerOf(
        uint256 tokenId
    ) public view _requireMinted(tokenId) returns (address owner) {
        return _owners[tokenId];
    }

    function approve(address to, uint256 tokenId) public {
        address _owner = ownerOf(tokenId);

        require(
            _owner == msg.sender || isApprovedForAll(_owner, msg.sender),
            "Not an owner"
        );

        require(to != _owner, "Can not approve to self!");

        _tokenApprovals[tokenId] = to;
        emit Approval(_owner, to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(msg.sender != operator, "Can not approve self!");

        _operatorsApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(
        uint256 tokenId
    ) public view _requireMinted(tokenId) returns (address operator) {
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) public view returns (bool) {
        return _operatorsApprovals[owner][operator];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return (interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId));
    }

    function _safeMint(address to, uint tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(
        address to,
        uint tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);

        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "Non-ERC721 receiver"
        );
    }

    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0), "Zero address to");
        require(!_exists(tokenId), "This token id is already minted!");

        _beforeTokenTransfer(address(0), to, tokenId);

        delete _tokenApprovals[tokenId];

        _owners[tokenId] = to;
        _balances[to]++;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    function burn(uint tokenId) internal virtual {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not an Owner!");

        _burn(tokenId);
    }

    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        delete _tokenApprovals[tokenId];
        _balances[owner]--;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

    function _baseURI() internal pure virtual returns (string memory) {
        return "";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual _requireMinted(tokenId) returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    function _exists(uint tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(
        address spender,
        uint tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(tokenId);

        return (spender == owner ||
            isApprovedForAll(owner, spender) ||
            getApproved(tokenId) == spender);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _tranfer(from, to, tokenId);

        require(
            _checkOnERC721Received(from, to, tokenId, data),
            "Transfer to non-ERC721 receiver!"
        );
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(from, to, tokenId, data)
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("Transer to non-ERC721 recevier!");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _tranfer(address from, address to, uint tokenId) internal {
        require(ownerOf(tokenId) == from, "Incorrect owner!");
        require(to != address(0), "To addres is Zero!");

        _beforeTokenTransfer(from, to, tokenId);

        delete _tokenApprovals[tokenId];

        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint tokenId
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint tokenId
    ) internal virtual {}
}
