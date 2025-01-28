import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre, { ethers } from "hardhat";

describe("AuctionTxOrigin", function () {
  console.log("AuctionTxOrigin")
  async function deployAuctionTxOriginFixture() {
    const [owner, hacker] = await ethers.getSigners();

    const actionAmount = ethers.parseEther("3");

    const Auction = await ethers.getContractFactory("AuctionTxOrigin");
    const auction = await Auction.deploy({ value: actionAmount });
    await auction.waitForDeployment();


    const Hack = await ethers.getContractFactory("HackTxOringin", hacker);
    const hack = await Hack.deploy(auction.target, { value: 500 });
    await hack.waitForDeployment();

    return { auction, hack, owner, actionAmount };
  }

  it("Allows to hack auction", async function () {
    const { auction, hack, owner, actionAmount } = await loadFixture(deployAuctionTxOriginFixture);
    // console.log("🚀 ~ hack:", hack)

    const hackTx = await hack.connect(owner).getYourMoney();
    await hackTx.wait();
    // console.log('hackTx', hackTx)
    console.log('actionAmount', actionAmount)

    expect(hackTx).to.changeEtherBalances(
      [auction, hack], [-actionAmount, actionAmount]
    )
  })
});
