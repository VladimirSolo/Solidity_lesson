// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./ExampleToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

struct Item {
    uint256 price;
    uint256 quantity;
    string name;
    bool exists;
}

struct ItemInStock {
    bytes32 uid;
    uint256 price;
    uint256 quantity;
    string name;
}

struct BoughtItem {
    bytes32 uniqueld;
    uint256 numOfPurchasedItems;
    string deliveryAddress;
}

contract ShopToken is Ownable {
    mapping(bytes32 => Item) public items;
    bytes32[] public uniqueIds;

    mapping(address => BoughtItem[]) public buyers;
    ExampleToken public token;

    constructor(address _token) Ownable(msg.sender) {
        token = ExampleToken(_token);
    }

    function addItem(
        uint _price,
        uint _quantity,
        string calldata _name
    ) external onlyOwner returns (bytes32 uid) {
        uid = keccak256(abi.encode(_price, _name));

        items[uid] = Item({
            price: _price,
            name: _name,
            quantity: _quantity,
            exists: true
        });

        uniqueIds.push(uid);
    }

    function buy(
        bytes32 _uid,
        uint _numOfItems,
        string calldata _address
    ) external {
        Item storage itemToBuy = items[_uid];

        require(itemToBuy.exists);
        require(itemToBuy.quantity >= _numOfItems);

        uint totalPrice = _numOfItems * itemToBuy.price;
        token.transferFrom(msg.sender, address(this), totalPrice);

        itemToBuy.quantity -= _numOfItems;

        buyers[msg.sender].push(
            BoughtItem({
                uniqueld: _uid,
                numOfPurchasedItems: _numOfItems,
                deliveryAddress: _address
            })
        );
    }

    function availableItems(
        uint _page,
        uint _count
    ) external view returns (ItemInStock[] memory) {
        require(_page > 0 && _count > 0);

        uint totalItems = uniqueIds.length;

        ItemInStock[] memory stockItems = new ItemInStock[](_count);

        uint counter;

        for (uint i = _count * _page - _count; i < _count * _page; ++i) {
            if (i >= totalItems) break;

            bytes32 currentUid = uniqueIds[i];
            Item storage currentItem = items[currentUid];

            stockItems[counter] = ItemInStock({
                uid: currentUid,
                price: currentItem.price,
                quantity: currentItem.quantity,
                name: currentItem.name
            });

            ++counter;
        }
        return stockItems;
    }
}

/* 
function availableItems(
        uint _page,
        uint _count
    ) external view returns (ItemInStock[] memory) {
        require(_page > 0, "Page number must be greater than 0");
        require(_count > 0, "Count must be greater than 0");

        uint totalItems = uniqueIds.length;
        uint startIndex = (_page - 1) * _count;

        // Проверка: если начальный индекс больше общего количества товаров
        if (startIndex >= totalItems) {
            return new ItemInStock Возвращаем пустой массив
        }

        // Количество элементов на странице
        uint itemsOnPage = totalItems - startIndex < _count
            ? totalItems - startIndex
            : _count;

        ItemInStock[] memory stockItems = new ItemInStock[](itemsOnPage);
        uint counter;

        for (uint i = startIndex; i < startIndex + itemsOnPage; i++) {
            bytes32 currentUid = uniqueIds[i];
            Item storage currentItem = items[currentUid];

            if (!currentItem.exists) continue; // Игнорируем несуществующие товары

            stockItems[counter] = ItemInStock({
                uid: currentUid,
                price: currentItem.price,
                quantity: currentItem.quantity,
                name: currentItem.name
            });

            counter++;
        }

        return stockItems;
    }
 */
