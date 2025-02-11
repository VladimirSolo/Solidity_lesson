// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract TodoList {
    address public owner;
    struct Todo {
        string title;
        string description;
        bool completed;
    }

    // Todo[] public todos; // all can
    Todo[] todos; // only owner can get

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner!");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addTodo(
        string calldata _title,
        string calldata _description
    ) external onlyOwner {
        todos.push(Todo(_title, _description, false));
    }

    function changeTodoTitle(
        string calldata _newTitle,
        uint256 index
    ) external onlyOwner {
        todos[index].title = _newTitle; // if one field and gas less

        /*
        Todo storage myTodo = todos[index];
        myTodo.title = _newTitle;
         */
    }

    function getTodo(
        uint256 index
    ) external view onlyOwner returns (string memory, string memory, bool) {
        // Todo memory myTodo = todo[index];
        Todo storage myTodo = todos[index]; // gas less then memory usage

        return (myTodo.title, myTodo.description, myTodo.completed);
    }

    function changeTodoStatus(uint256 index) external onlyOwner {
        todos[index].completed = !todos[index].completed; // if one field and gas less
    }
}
