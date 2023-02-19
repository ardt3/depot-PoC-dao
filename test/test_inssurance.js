const { expect } = require("chai");
const { ethers } = require("hardhat");
const { randomBytes } = require('crypto');
const { keccak256 } = require('ethereumjs-util');

describe("Dao", function() {
  it("should init the dao", async function() {
    const Dao = await ethers.getContractFactory("Dao");
    const dao = await Dao.deploy();


    const ownerAddr = ethers.Wallet.createRandom().address;
    const owner = await dao.connect(ownerAddr).createNewUser("Tartempion Toto", "FR", true);
    await dao.addUser(owner);

    const user1Addr = ethers.Wallet.createRandom().address;
    const user1 = await dao.connect(user1Addr).createNewUser("Tartempion Tutu", "EN", false);
    await dao.addUser(user1);

    const user2Addr = ethers.Wallet.createRandom().address;
    const user2 = await dao.connect(user2Addr).createNewUser("Tartempion Titi", "EN", false);
    await dao.addUser(user2);


    await dao.createProposal("Une description");
    await dao.vote(0);
    await dao.vote(0);


    await dao.execProposal(0);
  });
});
