// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract FixedMagicAnimalCarousel {
    // Определяем структуру для хранения данных о животном в карусели
    struct AnimalCrate {
        string animalName; // Имя животного
        uint16 nextId; // ID следующей ячейки
        address owner; // Владелец ячейки
    }

    uint16 public constant MAX_CAPACITY = type(uint16).max;
    uint16 public currentCrateId;

    // Используем маппинг с четкой структурой вместо битовых манипуляций
    mapping(uint256 crateId => AnimalCrate) public carousel;

    // События для отслеживания изменений
    event AnimalAdded(
        uint256 indexed crateId,
        string animalName,
        address indexed owner
    );
    event AnimalChanged(
        uint256 indexed crateId,
        string animalName,
        address indexed owner
    );

    // Ошибки
    error AnimalNameTooLong();
    error NotTheOwner();
    error EmptyAnimalName();
    error CrateNotInitialized();

    constructor() {
        // Инициализируем карусель, устанавливая nextId для первой ячейки
        carousel[0].nextId = 1;
    }

    /**
     * @dev Добавляет новое животное в карусель и перемещает указатель текущей ячейки
     * @param animalName Имя животного для добавления
     */
    function setAnimalAndSpin(string calldata animalName) external {
        // Проверяем, что имя животного не пустое
        if (bytes(animalName).length == 0) revert EmptyAnimalName();

        // Проверяем, что имя животного не слишком длинное
        validateAnimalName(animalName);

        // Получаем ID следующей ячейки
        uint16 nextCrateId = carousel[currentCrateId].nextId;

        // Обновляем данные в ячейке
        carousel[nextCrateId].animalName = animalName;
        carousel[nextCrateId].nextId = (nextCrateId + 1) % MAX_CAPACITY;
        carousel[nextCrateId].owner = msg.sender;

        // Обновляем текущую ячейку
        currentCrateId = nextCrateId;

        emit AnimalAdded(nextCrateId, animalName, msg.sender);
    }

    /**
     * @dev Изменяет животное в указанной ячейке, если вызывающий является владельцем
     * @param animalName Новое имя животного
     * @param crateId ID ячейки для изменения
     */
    function changeAnimal(
        string calldata animalName,
        uint256 crateId
    ) external {
        // Проверяем, что ячейка инициализирована (имеет владельца)
        if (carousel[crateId].owner == address(0)) revert CrateNotInitialized();

        // Проверяем, что вызывающий является владельцем ячейки
        if (carousel[crateId].owner != msg.sender) revert NotTheOwner();

        // Проверяем, что имя животного не слишком длинное
        validateAnimalName(animalName);

        // Обновляем имя животного
        carousel[crateId].animalName = animalName;

        emit AnimalChanged(crateId, animalName, msg.sender);
    }

    /**
     * @dev Валидирует имя животного
     * @param animalName Имя для проверки
     */
    function validateAnimalName(string calldata animalName) public pure {
        // Проверяем длину имени в байтах
        uint256 nameLength = bytes(animalName).length;

        // Ограничиваем длину имени 10 символами (вместо 12 байт)
        // Это защищает от проблем с многобайтовыми символами
        if (nameLength > 10) revert AnimalNameTooLong();

        // Дополнительная проверка на многобайтовые символы
        // Это более сложная реализация, требующая цикла для подсчета
        // реальных символов вместо байтов, опущена для простоты
    }

    /**
     * @dev Получает информацию о животном в ячейке
     * @param crateId ID ячейки
     * @return animalName Имя животного
     * @return nextId ID следующей ячейки
     * @return owner Владелец ячейки
     */
    function getAnimalInfo(
        uint256 crateId
    )
        external
        view
        returns (string memory animalName, uint16 nextId, address owner)
    {
        AnimalCrate memory crate = carousel[crateId];
        return (crate.animalName, crate.nextId, crate.owner);
    }
}
