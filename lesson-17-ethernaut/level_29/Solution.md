### Безопасная версия

```solidity
modifier onlyOff() {
    require(
        keccak256(abi.encode(_data)) == keccak256(abi.encode(abi.encodeWithSignature("turnSwitchOff()"))),
        "Can only call the turnOffSwitch function"
    );
    _;
}
```

```solidity
// Безопасная версия с явной проверкой аргумента
function flipSwitch(bytes4 functionSelector, bytes memory _data) public {
    require(
        functionSelector == bytes4(keccak256("turnSwitchOff()")),
        "Can only call the turnOffSwitch function"
    );
    (bool success, ) = address(this).call(_data);
    require(success, "call failed :(");
}
```

```solidity
modifier onlyOff(bytes memory _data) {
    // Проверяем, что _data содержит только селектор turnSwitchOff()
    require(_data.length == 4, "Data must be exactly 4 bytes");

    bytes4 selector;
    assembly {
        selector := mload(add(_data, 32))
    }

    require(
        selector == bytes4(keccak256("turnSwitchOff()")),
        "Can only call the turnOffSwitch function"
    );
    _;
}
```

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeSwitch {
    bool public switchOn; // switch is off

    enum Action { OFF, ON }

    function flipSwitch(Action action) public {
        if (action == Action.ON) {
            _turnSwitchOn();
        } else {
            _turnSwitchOff();
        }
    }

    function _turnSwitchOn() private {
        switchOn = true;
    }

    function _turnSwitchOff() private {
        switchOn = false;
    }
}
```

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SaferSwitch {
    bool public switchOn; // switch is off
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

    modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    // Проверяем весь calldata, а не только его часть
    function flipSwitch(bytes memory _data) public {
        // Проверка, что _data содержит только вызов turnSwitchOff()
        require(_data.length >= 4, "Invalid data length");
        bytes4 selector;
        assembly {
            // Берем первые 4 байта из _data
            selector := mload(add(_data, 32))
        }

        require(
            selector == offSelector,
            "Can only call the turnOffSwitch function"
        );

        // Дополнительная проверка, что ничего кроме селектора нет
        // или остальные данные соответствуют сигнатуре функции
        if (_data.length > 4) {
            // Проверка остальных данных, если они есть
            // Например, проверка, что это аргументы turnSwitchOff()
        }

        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
    }
}
```

### Ключевые уроки безопасности

- **Избегайте прямого доступа к calldata через ассемблер**, когда это возможно. Если его использование необходимо, тщательно проверяйте все данные.
- **Не делайте предположений о структуре calldata** - всегда проверяйте полное содержимое данных, а не только их части.
- **Используйте стандартные механизмы Solidity** для разбора и проверки параметров функций.
- **Не доверяйте пользовательским данным** - особенно при использовании низкоуровневых функций, таких как `call()` и `delegatecall()`.
- **Применяйте принцип минимальных привилегий** - ограничивайте возможности функций только необходимыми для их работы действиями.
- **Рассмотрите более простые архитектурные решения**, которые не требуют сложных проверок и манипуляций с низкоуровневым кодом.

> Устранение уязвимостей в смарт-контрактах - это баланс между безопасностью, удобством использования и расходом газа. В большинстве случаев лучше пожертвовать небольшим количеством газа ради значительного повышения безопасности.
