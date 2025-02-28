import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";
import { ethers } from "hardhat";

describe("Token", function () {

  async function deployTokenFixture() {
    const [deployer, user] = await ethers.getSigners();

    const TokenFactory = await ethers.getContractFactory('Token');
    const token = await TokenFactory.deploy();
    await token.waitForDeployment()

    const TokenAsDeployerFactory = await ethers.getContractFactory('Token', deployer);
    const tokenAsDeployer = await TokenAsDeployerFactory.deploy();
    await tokenAsDeployer.waitForDeployment()

    return { token, deployer, user, tokenAsDeployer };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { token, deployer } = await deployTokenFixture();
      expect(await token.owner()).to.equal(deployer.address);
    });

    it("Should safe mint", async function () {
      const { token, user, deployer, tokenAsDeployer } = await deployTokenFixture();
      const tokenId = "example-uri";

      console.log("Before mint - totalSupply:", await token.totalSupply());

      await expect(token.safeMint(user.address, tokenId))
        .to.emit(token, "Transfer")
        .withArgs(ethers.ZeroAddress, user.address, 0);

      expect(await token.ownerOf(0)).to.equal(user.address);
      expect(await token.tokenURI(0)).to.equal(`ipfs://${tokenId}`);

      // const tokenIdSecond = "example-uri-second";
      // const mint = await token.safeMint(user, tokenIdSecond);
      // await mint.wait();

      console.log("Total Supply:", await token.totalSupply());
      // console.log("Token IDs:", await token.tokenByIndex(0), await token.tokenByIndex(1));


      const tokenId3 = "example-uri-3";
      const mint3 = await token.safeMint(deployer, tokenId3);
      await mint3.wait();

      expect(await token.tokenURI(1)).to.equal(`ipfs://${tokenId3}`);

      const userTokenId = await token.tokenOfOwnerByIndex(user, 0)
      expect(userTokenId).to.eq(0); // 0n

      expect(await token.totalSupply()).to.eq(2);
      expect(await token.tokenOfOwnerByIndex(deployer, 0)).to.eq(1); // 1n

      expect(await token.ownerOf(userTokenId)).to.eq(user)

      // TODO: errros not an owner - need rewrite code tests

      // const approveTx = await token.approve(deployer, userTokenId);
      // approveTx.wait();

      // const transfer = await tokenAsDeployer.transferFrom(user, deployer, userTokenId);
      // transfer.wait();

      // expect(await token.ownerOf(userTokenId)).to.eq(deployer)

    });

    it("Should not allow non-owner to mint", async function () {
      const { token, user } = await deployTokenFixture();
      await expect(
        token.connect(user).safeMint(user.address, "test")
      ).to.be.revertedWith("Not an owner!");
    });
  });
});
