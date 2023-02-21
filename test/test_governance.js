const { expect } = require("chai");
const { ethers } = require("hardhat");
const { randomBytes } = require('crypto');
const { keccak256 } = require('ethereumjs-util');

describe("Dao", function() {

  let dao;
  let owner;
  let user1;
  let user2;
  let user3;
  let user4;
  let user5;

  beforeEach(async () => {
    const Dao = await ethers.getContractFactory("Dao");
    [owner, user1, user2, user3, user4, user5] = await ethers.getSigners();
    dao = await Dao.deploy();


    owner = await dao.connect(owner.address).createNewUser("Tartempion Toto", "FR", true);
    await dao.setGeneralGovernance(owner, 5, true, "contract");

    user1 = await dao.connect(user1.address).createNewUser("Tartempion Tutu", "EN", false);
    user2 = await dao.connect(user2.address).createNewUser("Tartempion Titi", "EN", false);
    user3 = await dao.connect(user3.address).createNewUser("Tartempion Tata", "EN", false);
    user4 = await dao.connect(user4.address).createNewUser("Tartempion Tete", "EN", false);
    user5 = await dao.connect(user5.address).createNewUser("Tartempion Tyty", "EN", false);

    await dao.addUser(owner);
    await dao.addUser(user1);
    await dao.addUser(user2);
    await dao.addUser(user3);
    await dao.addUser(user4);
  });

  it("should be pass", async function() {
    await dao.createProposal("Description", owner.addr);
    await dao.vote(0, user1.addr);
    await dao.vote(0, user2.addr);
    await dao.execProposal(0);
  });

  it("shouldn't work, the proposal is not voted enough ", async function() {
    await dao.createProposal("Description", owner.addr);
    await dao.vote(0, user1.addr);
    await dao.execProposal(0);
  });

  it("shouldn't work, a non-member is trying to create a proposal", async function() {
    await dao.createProposal("Description", user5.addr);
  });

  it("shouldn't work, a non-member is trying to vote", async function() {
    await dao.createProposal("Description", user5.addr);
    await dao.vote(0, user5.addr);
  });

  it("shouldn't work, a non-owner is trying to set the general governance", async function() {
    await dao.setGeneralGovernance(user1, 3, true, "contract");
  });

  it("shouldn't work, too many registered users", async function() {
    await dao.addUser(user5);
  });
});
