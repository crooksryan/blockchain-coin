// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract CoinFlip{
    uint betAmount;
    bool coinFlipped;

    constructor(uint _betAmount){
        betAmount = _betAmount;
    }

    function flipAcoin() public returns(uint){
        require(!coinFlipped, "Coin already flipped");
        coinFlipped = true;

        return random();
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) % 2;
    }
}