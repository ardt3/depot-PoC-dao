// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "./inssurance.sol";

contract Dao is Inssurance{

    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    mapping(address => bool) public members;
    uint256 public memberCount;

    struct User{
        string name;
        string country;
        bool isOwner;
        address addr;
    }

    struct GovernanceValue{
        uint8 nbUserMax;
        bool profitable;
        string contractType;        
    }

    GovernanceValue public governance;

    struct Proposal {
        address creator;
        string description;
        uint256 voteCnt;
        address[] memberVoted;
        bool executed;
    }
    
    Proposal[] public proposals;


    function setGeneralGovernance(User memory user, uint8 nbUserMax, bool profitable, string memory contractType) public{ // add args
        require(user.isOwner, "Only owner can set the governance");

        governance.nbUserMax = nbUserMax;
        governance.profitable = profitable;
        governance.contractType = contractType;
    }

    function createNewUser(string memory name, string memory country, bool isOwner) public view returns(User memory){
        User memory newUser;

        newUser.name  = name;
        newUser.country = country;
        newUser.isOwner = isOwner;
        newUser.addr = msg.sender;

        return newUser;
    }

    function addUser(User memory newUser) public {
        require(!members[newUser.addr], "Member already exist");
        require(memberCount < governance.nbUserMax, "The limit of the number of users has been reached");

        members[newUser.addr] = true;
        memberCount++;
    }

    function removeUser(User memory userToRemove) public {
        require(members[userToRemove.addr], "Member doesn't exist");

        members[userToRemove.addr] = false;
        memberCount--;
    }

    function vote(uint proposalsIndex, address userAddr) public {
        Proposal storage proposal = proposals[proposalsIndex];
        require(members[userAddr], "Only members can vote");

        for (uint i = 0; i < proposal.memberVoted.length; i++) {
           require(proposal.memberVoted[i] != userAddr, "Member has already voted");
        }

        proposal.memberVoted.push(userAddr);
        proposal.voteCnt++;
    }

    function createProposal(string memory description, address userAddr) public { 
        require(members[userAddr], "Only members can create proposals");

        proposals.push(Proposal({
            creator: userAddr,
            description: description,
            voteCnt: 0,
            memberVoted: new address[](0),
            executed: false
        }));
        Proposal storage proposal = proposals[proposals.length-1];
        proposal.memberVoted.push(userAddr);
        proposal.voteCnt++;
    }

    function execProposal(uint proposalsIndex) public { // trouver un moyen pour appeler la fonction a exec
        Proposal storage proposal = proposals[proposalsIndex];
        require(!proposal.executed, "Proposal has already been executed");
        require(proposal.voteCnt > memberCount / 2, "Proposal does not have enough votes");

        proposal.executed = true;
        // trouver un moyen pour appeler la fonction a exec
    }

    function getAddr() public view returns (address){
        return msg.sender;
    }

}