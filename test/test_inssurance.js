const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Dao", function() {
  it("should init the dao", async function() {
    const Dao = await ethers.getContractFactory("Dao");
    const dao = await Dao.deploy();

    const owner = await dao.createNewUser("Tartempion Toto", "FR", true);
    await dao.setGovernance(owner, 3, true, "inssurance");

    const daoRules = await dao.rules();

    console.log("L'utilisateur est: ", owner.name);
    console.log("Originaire de: ", owner.country);
    console.log("Il est admin: ", owner.isOwner);
    console.log("Sont addr: ", owner.addr);
    expect(owner.name).to.equal("Tartempion Toto");
    expect(owner.country).to.equal("FR");
    expect(owner.isOwner).to.equal(true);

    console.log("Nombre d'utilisateur de la dao: ", daoRules.nbUser);
    console.log("Profitable: ", daoRules.profitable);
    expect(daoRules.nbUser).to.equal(3);
    expect(daoRules.profitable).to.equal(true);

    const user2 = await dao.createNewUser("Tartempion Tata", "EN", false);

    console.log("L'utilisateur est: ", user2.name);
    console.log("Originaire de: ", user2.country);
    console.log("Il est admin: ", user2.isOwner);
    console.log("Sont addr: ", user2.addr);
    expect(owner.name).to.equal("Tartempion Toto");
    expect(owner.country).to.equal("FR");
    expect(owner.isOwner).to.equal(true);

    const test = await dao.setInssuranceGovernance();
    console.log("test: ", test);

  });
});