const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Contract landManager", () => {
  let owner, addr1, addr2, landManager, landmanager;
  
  beforeEach(async () => {
    landManager = await ethers.getContractFactory("landManager");
    landmanager = await landManager.deploy("10","10");
    [owner, addr1, addr2, _]  = await ethers.getSigners();
    await landmanager.deployed();
  });

  describe("Check Deployment", () => {
      it("Should get the xLandLimit", async () => {
        expect(await landmanager.xLandLimit()).to.equal("10");
      });
      it("Should get the yLandLimit", async () => {
        expect(await landmanager.yLandLimit()).to.equal("10");
      });
  });

  describe("Deployment", () => {

});

  describe("Check the behaviour of functions", () => {
    it("Should assign property land to the deployer and check if it's owned", async ()  =>{
      await landmanager.assignProperty(owner.address,"1","1");
      let isItOK =  await landmanager.isThisLandOwned("1","1","1","1");
      expect(isItOK).to.equal(true);
    });

    it("Should check that a free land is not owned", async () => {
      let isItKO =  await landmanager.isThisLandOwned("2","3","2","3");
      expect(isItKO).to.equal(false);
    });

    it("Should assign property land to the address1 and check if it's owned", async ()  =>{
      await landmanager.assignProperty(addr1.address,"2","2");
      let isItOK =  await landmanager.isThisLandOwned("2","2","2","2");
      expect(isItOK).to.equal(true);
    });

    it("Should assign a land to the address2 and check if it's owned", async ()  =>{
      await landmanager.assignLand(addr2.address,"3","4","3","4");
      let isItOK =  await landmanager.isThisLandOwned("3","4","3","4");
      expect(isItOK).to.equal(true);
    });

    it("Should check if the function readLand returns the owner when his land is checked", async ()  =>{
      await landmanager.assignProperty(owner.address,"1","1");
      let ownerAddress = await landmanager.readLand("1","1");
      expect(ownerAddress).to.equal(owner.address);
    });

    it("Should check if an owner can submit a buying proposal", async ()  =>{
      await landmanager.assignLand(owner.address,"1","2","1","3");
      await landmanager.buyingProposalAndUpdateVote(owner.address, "3", "4", "3", "4");
    });

    it("Should check if an non-owner can not submit a buying proposal", async ()  =>{
      await landmanager.assignLand(addr1.address,"1","2","1","2");
      await landmanager.assignLand(addr2.address,"3","4","3","4");
      expect(landmanager.buyingProposalAndUpdateVote(owner.address, "3", "4", "3", "4")).to.be.revertedWith("this land is already owned");
    });


    it("Should check that we can vote only for the current proposal Id", async ()  =>{

      await landmanager.assignLand(addr1.address,"1","2","1","2");
      await landmanager.assignLand(addr2.address,"3","4","3","4");

      await landmanager.buyingProposalAndUpdateVote(addr2.address, "5", "6", "5", "6");
      expect(landmanager.voteForProposalAndUpdateVote(addr2.address,"3","true")).to.be.revertedWith("This is not the proposal currently in voting");

    
    });


    it("Should check that only an owner can vote", async ()  =>{

      await landmanager.assignLand(addr1.address,"1","2","1","2");
      await landmanager.assignLand(addr2.address,"3","4","3","4");

      await landmanager.buyingProposalAndUpdateVote(addr2.address, "5", "6", "5", "6");
      expect(landmanager.voteForProposalAndUpdateVote(owner.address,"1","true")).to.be.revertedWith("This address is not owner");

    
    });


    it("Should check that an address can vote only once for a proposal", async ()  =>{

      await landmanager.assignLand(addr1.address,"1","2","1","2");
      await landmanager.assignLand(addr2.address,"3","4","3","4");

      await landmanager.buyingProposalAndUpdateVote(addr2.address, "5", "6", "5", "6");
      await landmanager.voteForProposalAndUpdateVote(addr2.address,"1","true")
      expect(landmanager.voteForProposalAndUpdateVote(addr2.address,"1","true")).to.be.revertedWith("This address has already voted for this proposal");

    
    });
    

    it("Should check that we can vote only during the timing vote", async ()  =>{

      await landmanager.assignLand(addr1.address,"1","2","1","2");
      await landmanager.assignLand(addr2.address,"3","4","3","4");

      await landmanager.buyingProposalAndUpdateVote(addr2.address, "5", "6", "5", "6");
      await landmanager.voteForProposalAndUpdateVote(addr2.address,"1","true");

      await new Promise(resolve => setTimeout(resolve, 65000));
      expect(landmanager.voteForProposalAndUpdateVote(addr1.address,"1","true")).to.be.revertedWith("The time for voting on this proposal has passed");


    });



    it("Should check if an owner can submit buying proposal, vote and win the buying proposal", async ()  =>{

      await landmanager.assignLand(addr1.address,"1","2","1","2");
      await landmanager.assignLand(addr2.address,"3","4","3","4");

      await landmanager.buyingProposalAndUpdateVote(addr2.address, "5", "6", "5", "6");
      await landmanager.voteForProposalAndUpdateVote(addr2.address,"1","true");

      await new Promise(resolve => setTimeout(resolve, 65000));
      await landmanager.buyingProposalAndUpdateVote(addr1.address, "8", "9", "8", "9");

      ownerAddress = await landmanager.readLand("5","5");
      expect(ownerAddress).to.equal(addr2.address);
    });



    

  it("Should check if an owner can submit an extension of the map", async ()  =>{
      await landmanager.assignLand(addr1.address,"1","2","1","2");
      await landmanager.assignLand(addr2.address,"3","4","3","4");

      await landmanager.proposalForExtendingMaplAndUpdateVote(addr1.address, "20", "20");


  });



  it("Should check if an owner can submit an extension of the map and win the extension proposal", async ()  =>{
    await landmanager.assignLand(addr1.address,"1","2","1","2");
    await landmanager.assignLand(addr2.address,"3","4","3","4");

    await landmanager.proposalForExtendingMaplAndUpdateVote(addr1.address, "20", "20");

    await landmanager.voteForExtendProposalAndUpdateVote(addr1.address,"1","true");

    await new Promise(resolve => setTimeout(resolve, 65000));

    await landmanager.updateVote();

    expect(await landmanager.xLandLimit()).to.equal("20");
    expect(await landmanager.yLandLimit()).to.equal("20");

  });


});

  

});
