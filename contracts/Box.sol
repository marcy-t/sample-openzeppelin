// contracts/Box.sol
// SPDX-License-Identifier: MIT

// 8を使用しているので、最初に適切なsolcバージョンを使用するにHardhatを設定する必要があります
pragma solidity ^0.8.0;

// Import Ownable from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/access/Ownable.sol";

// Make Box inherit from the Ownable contract
contract Box is Ownable {
    uint256 private _value;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value); // 保存されたされた値が変更されたときに発行される

    // The onlyOwner modifier restricts who can call the store function
    // onlyOwner修飾子は、store関数を呼び出すことができる人を制限します
    function store(uint256 value) public onlyOwner { 
        _value = value;
        emit ValueChanged(value);
    }

    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        return _value;
    }
}