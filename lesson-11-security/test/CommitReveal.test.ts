import {

  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("CommitReveal", function () {
  async function deployCommitRevealFixture() {
    const [owner] = await ethers.getSigners();
    console.log(owner.address)
    const secretNumber = 42;

    const salt = ethers.solidityPackedKeccak256(
      ["string"], ["secret phrase"]
    );

    const hashedSecretNumber = ethers.solidityPackedKeccak256(
      ["address", "uint256", "bytes32"], [owner.address, secretNumber, salt]
    );

    const CommitRevealFactory = await ethers.getContractFactory("CommitReveal");
    const commitReveal = await CommitRevealFactory.deploy(hashedSecretNumber);
    await commitReveal.waitForDeployment();

    return { commitReveal, salt, secretNumber };
  }

  it("Commit Reveal", async function () {
    const { commitReveal, salt, secretNumber } = await loadFixture(deployCommitRevealFixture);

    expect(await commitReveal.secretNumber()).to.eq(0);

    await expect(commitReveal.reveal(77, salt)).to.be.revertedWith("invalid reveal!");

    const txReveal = await commitReveal.reveal(secretNumber, salt);
    await txReveal.wait();

    expect(await commitReveal.secretNumber()).to.eq(secretNumber);
  });
});
