// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "./inssurance.sol";

contract Dao is Inssurance{

    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    address public owner;

    struct user{
        string name;
        string country;
        bool isOwner;
        address addr;
    }

    struct daoRules{
        uint8 nbUser;
        bool profitable;
        string contractType;        
    }

    daoRules public rules;


    constructor() {
        owner == msg.sender;
    }

    function setGenralGovernance(user memory applicant, uint8 nbUser, bool profitable, string memory contractType) public{
        require(applicant.addr == owner, "Only owner can set the governance");

        rules.nbUser = nbUser;
        rules.profitable = profitable;
        rules.contractType = contractType;
    }

    function createNewUser(string memory name, string memory country, bool isOwner) public view returns(user memory){
        user memory newUser;

        newUser.name  = name;
        newUser.country = country;
        newUser.isOwner = isOwner;
        if (isOwner) {
            newUser.addr = owner;
        } else {
            newUser.addr = msg.sender;   
        }

        return newUser;
    }

    function removeUser() public {

    }

    function vote() public {

    }

    function createProposal() public {

    }

    function execProposal() public {

    }

}