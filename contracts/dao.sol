// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract dao {

    struct user{
        string name;
        string country;
        string role;
        bool owner;
        uint8 id;
    }

    struct daoRules{
        uint8 nbUser;
        bool profitable;        
    }


    function initDao(string memory name, string memory country, string memory role, uint8 nbUser, bool profitable) public pure returns(user memory, daoRules memory){
        daoRules memory rules;

        rules.nbUser = nbUser;
        rules.profitable = profitable;

        user memory ownerUser = createNewUser(name, country, role, true, 0); 

        return (ownerUser, rules);
    }


    function createNewUser(string memory name, string memory country, string memory role, bool owner, uint8 id) public pure returns(user memory){
        user memory newUser;

        newUser.name  = name;
        newUser.country = country;
        newUser.role = role;
        newUser.owner = owner;
        newUser.id = id;

        return newUser;
    }
}