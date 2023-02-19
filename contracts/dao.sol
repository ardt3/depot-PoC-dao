// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "./inssurance.sol";

contract Dao is Inssurance{

    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    address public owner;

    mapping(address => bool) public members;
    uint256 public memberCount;

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

    struct Proposal {
        address creator;
        string description;
        uint256 voteCnt;
        //address[] memberVoted;
        bool executed;
    }
    
    Proposal[] public proposals;


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
        newUser.addr = msg.sender;

        return newUser;
    }

    function addUser(user memory newUser) public {
        require(!members[newUser.addr], "Member already exist");
        members[newUser.addr] = true;
        memberCount++;
    }
    

    function removeUser(user memory userToRemove) public {
        require(members[userToRemove.addr], "Member doesn't exist");
        members[userToRemove.addr] = false;
        memberCount--;
    }

    function vote(uint proposalsIndex) public {
        Proposal storage proposal = proposals[proposalsIndex];
        //require(members[msg.sender], "Only members can vote");
        //for (uint i = 0; i < proposal.memberVoted.length; i++) {
        //    require(proposal.memberVoted[i] != msg.sender, "Member has already voted");
        //}

       // proposal.memberVoted.push(msg.sender);
        proposal.voteCnt++;
    }

    function createProposal(string memory description) public { 
        //require(members[msg.sender], "Only members can create proposals");
        
        //address[] memory creatorVote;
        //creatorVote[0] = msg.sender;

        proposals.push(Proposal({
            creator: msg.sender,
            description: description,
            voteCnt: 0,
            //memberVoted: creatorVote,
            executed: false
        }));
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