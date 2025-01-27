import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("HoneyPot hack", function () {
  async function deployBankFixture() {
    const [owner, attacker] = await ethers.getSigners();

    const HoneyPotFactory = await ethers.getContractFactory("HoneyPot");
    const honeyPot = await HoneyPotFactory.deploy();
    await honeyPot.waitForDeployment();

    const BankFactory = await ethers.getContractFactory("Bank");
    const bank = await BankFactory.deploy(honeyPot.target);
    await bank.waitForDeployment();

    return { bank, honeyPot, owner, attacker };
  }

  it("Should allow deposits", async function () {
    const { bank, owner } = await loadFixture(deployBankFixture);
    await bank.connect(owner).deposit({ value: 1000 });

    expect(await bank.balances(owner.address)).to.equal(1000);
  });

  it("Should block the output ->>(HoneyPot)", async function () {
    const { bank, honeyPot, owner, attacker } = await loadFixture(deployBankFixture);
    await bank.connect(attacker).deposit({ value: 1000 });

    expect(await bank.balances(attacker.address)).to.equal(1000);

    await expect(bank.connect(attacker).withdraw(1000)).to.be.revertedWith("HoneyPot triggered!");

    expect(await bank.balances(attacker.address)).to.equal(1000);
  });

  it("Allows to hack", async function () {
    const { bank } = await loadFixture(deployBankFixture);
    const tx = await bank.deposit({ value: 1000 });
    await tx.wait();

    await expect(bank.withdraw(1000)).to.be.reverted;
  })
});
