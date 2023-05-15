// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "./inssurance.sol";

contract Dao is Inssurance{

    // rôle de l'utilisateur 
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    // tableau contenant les différents membres avec leur adresse associée
    mapping(address => bool) public members;
    uint256 public memberCount; // contient le nombre de membres présent dans la dao

    // Structure contenant les informations de l'utilisateur
    struct User{ 
        string name;
        string country;
        bool isOwner;
        address addr;
    }

    // structure contenant les informations de la gouvernance
    struct GovernanceValue{
        uint8 nbUserMax;
        bool profitable;
        string contractType;        
    }

    // instance de la structure ; permet par la suite d'accéder aux informations de la structure ci-dessus
    GovernanceValue public governance;

    // structure contenant les informations d'une proposition
    struct Proposal {
        address creator;
        string description;
        uint256 voteCnt;
        address[] memberVoted;
        bool executed;
    }
    
    // Chaque proposition correspond à une instance de la structure Proposal, toutes les instances seront mises dans ce tableau
    // on pourra par exemple accéder aux créateurs de la porposition 1 avec proposals[0].creator
    Proposal[] public proposals;

    // fonction permettant de configurer la gouvernance à la suite de la KYC, les reponses sont en arguments de la fonctions
    function setGeneralGovernance(User memory user, uint8 nbUserMax, bool profitable, string memory contractType) public{ // add args
        // seulement les owner peuvent configurer la gouvernance, s'il ne posséde pas les droits (cf struct User) alors ils y a une erreur
        require(user.isOwner, "Only owner can set the governance");

        // on set les réponses de la KYC (arg de la fn) dans la structure GovernanceValue avec l'instnace governance
        governance.nbUserMax = nbUserMax; 
        governance.profitable = profitable;
        governance.contractType = contractType;
    }

    // fonction permettant la création d'un nouvelle utilisateur
    function createNewUser(string memory name, string memory country, bool isOwner) public view returns(User memory){
        // création d'un nouvelle utilisateur (nouvelle instance de la structure User)
        User memory newUser;

        // on set ses param
        newUser.name  = name;
        newUser.country = country;
        newUser.isOwner = isOwner;
        newUser.addr = msg.sender;

        // permet de retourner le nouvelle utilisateur créer avec les arg données
        return newUser;
    }

    // permet d'ajouter un utilisateur à la Dao
    function addUser(User memory newUser) public {
        require(!members[newUser.addr], "Member already exist"); // il faut qu'il n'existe pas, donc on vérifie que sont address ne fait pas parti du tableau membre
        require(memberCount < governance.nbUserMax, "The limit of the number of users has been reached"); // il ne faut pas que la limite d'utilisateur soit atteinte

        // si tous les requierements précédents sont ok alors on l'ajoute au tableau des membres et on incrémente le nombre de user
        members[newUser.addr] = true;
        memberCount++;
    }

    // permet de supprimer un utilisateur de la dao
    function removeUser(User memory userToRemove) public {
        require(members[userToRemove.addr], "Member doesn't exist"); // faut d'abord vérifier s'il est membre

        // si c'est le cas alors on le supprime et on décrémente le conteur de membre
        members[userToRemove.addr] = false;
        memberCount--;
    }

    // fonction qui permet de réaliser un vote, il faut spécifier l'@ du user et le numéro de la proposition
    function vote(uint proposalsIndex, address userAddr) public {
        Proposal storage proposal = proposals[proposalsIndex];
        require(members[userAddr], "Only members can vote"); // on vérifie qu'il est membre

        for (uint i = 0; i < proposal.memberVoted.length; i++) {
           require(proposal.memberVoted[i] != userAddr, "Member has already voted"); // on vérifie qu'il n'a pas déjà voté
        }

        proposal.memberVoted.push(userAddr); // sinon on prend en compte sont vote
        proposal.voteCnt++; // on incrémente le nombre de vote pour la proposition concerné
    }

    // fonction qui permet de créer une proposition, on doit spécifier une description et l'@ du cre2ateur
    function createProposal(string memory description, address userAddr) public { 
        require(members[userAddr], "Only members can create proposals"); // il doit obligatoirement e3tre membre

        // on ajoute la proposition
        proposals.push(Proposal({
            creator: userAddr,
            description: description,
            voteCnt: 0,
            memberVoted: new address[](0),
            executed: false
        }));
        Proposal storage proposal = proposals[proposals.length-1];
        proposal.memberVoted.push(userAddr); // et on le fait voter
        proposal.voteCnt++; // on incrémente
    }

    // fonction qui permet d'exécuter la proposition, il doit y avoir un appel à la fonction de la proposition 
    // en question que je n'ai pas fait 
    function execProposal(uint proposalsIndex) public { // trouver un moyen pour appeler la fonction a exec
        Proposal storage proposal = proposals[proposalsIndex];
        require(!proposal.executed, "Proposal has already been executed");
        require(proposal.voteCnt > memberCount / 2, "Proposal does not have enough votes");

        proposal.executed = true;
        // trouver un moyen pour appeler la fonction a exec
    }

    // permet de retourner l'@ de l'utilisateur qui appel la fonction
    function getAddr() public view returns (address){
        return msg.sender;
    }

}
