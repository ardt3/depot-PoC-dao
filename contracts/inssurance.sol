// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Inssurance{

  uint public balance;

  function setInssuranceGovernance() public pure returns (string memory){
    return "toto";
  }

  function deposit() public payable {
      balance += msg.value;
  }

  function withdraw(uint amount) public {
      require(amount <= balance, "Insufficient funds");
      balance -= amount;
  }

  function getBalance() public {

  }
  
}