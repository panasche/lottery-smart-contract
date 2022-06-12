// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract pr1{

    address public manager;
    address payable[] participants;

    constructor(){
        manager=msg.sender;
    }

    receive() external payable{
        require(msg.value==2 ether);
        participants.push(payable(msg.sender));
    }

    function checkBal() public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public{
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r= random();
        address payable winner;
        uint index= r%participants.length;
        winner=participants[index];
        winner.transfer(checkBal());
        participants= new address payable[](0);
        manager=winner;
    }
}