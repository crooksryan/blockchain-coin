// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract coinFlip{
    address public flipper;
    uint amount;

    event Flipped(bool result);

    constructor(){
        flipper = msg.sender;
    }

    function flipACoin(uint choice) public payable{
        require(msg.value > 0, "Invalid bet amount");

        uint value = decide(choice, msg.value);

        // win case
        if(value == 1){
            amount -= 2 * msg.value;
            payable(msg.sender).transfer(2 * msg.value);
            emit Flipped(true);
        }
        // lose case
        else{
            amount += msg.value;
            if(amount > 500){
                payable(flipper).transfer(5);
                amount -= 5;
            }
            emit Flipped(false);
        }
    }

    function decide(uint choice, uint money) private returns(uint){
        require(msg.value > 0, "Invalid bet amount");

        // win case
        if(random() == choice){
            // if contract hold enough to pay out
            if(amount >= 2 * money){
                return 1;
            }
        }
        // lose case
        return 0;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) % 2;
    }
}