// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Chatapp{
    address owner;
    
    struct Message{
        string content;
    }
    struct Chat{
        address sender;
        address receiver;
        string[] messages;
    }
    
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(owner == msg.sender);_;
    }

    mapping(address=>Chat[]) private personalChats;

    function createMessage(address receiver,string memory content) public {
        Chat[] storage chats = personalChats[msg.sender];
        for (uint256 i = 0; i < chats.length; i++) {
            if (chats[i].receiver == receiver) {
                chats[i].messages.push(content);
                return;
            }
        }


    }

    function addChat(address receiver , string memory message ) public{
        Chat[] storage chats = personalChats[msg.sender];
        for (uint256 i = 0; i < chats.length; i++) {
            if (chats[i].receiver == receiver) {
                chats[i].messages.push(message);
                return;
            }
        }
        chats.push(Chat(msg.sender, receiver, new string[](1)));
        chats[chats.length - 1].messages[0] = message;
    }

    

    function deleteChat(address receiver) public {
        Chat[] storage chats = personalChats[msg.sender];
        for (uint256 i = 0; i < chats.length; i++) {
            if (chats[i].receiver == receiver) {
                delete chats[i];
                return;
            }
        }
    }

    function deleteMessage(address receiver,string memory content ) public{
        Chat[] storage chats = personalChats[msg.sender];
        for (uint256 i = 0; i < chats.length; i++) {
            if (chats[i].receiver == receiver) {
                for (uint256 j = 0; j < chats[i].messages.length; j++) {
                    if (keccak256(abi.encodePacked(chats[i].messages[j])) == keccak256(abi.encodePacked(content))) {
                        delete chats[i].messages[j];
                        return;
                    }
                }
            }
        }
    }
    

    function viewChats() public view returns (Chat[] memory){
        return personalChats[msg.sender];
    }

}
