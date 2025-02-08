import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { ExampleToken } from "../typechain-types";

describe("TokenExchange", () => {
  async function deployTokenExchangeFixture() {
    const [owner, byuer] = await ethers.getSigners();

    const ExampleTokenFactory = await ethers.getContractFactory('ExampleToken');
    const token = await ExampleTokenFactory.deploy(owner.address);
    await token.waitForDeployment();

    const TokenExchangeFactory = await ethers.getContractFactory('TokenExchange');
    const exchange = await TokenExchangeFactory.deploy(token.target);
    await exchange.waitForDeployment();

    return { owner, byuer, token, exchange };
  }

  it("Should allow to buy", async () => {
    const { owner, byuer, token, exchange } = await loadFixture(deployTokenExchangeFixture);

    const tokenInStock = 3n;
    const tokenWithDecimals = await withDecimals(token, tokenInStock);

    const transferTx = await token.transfer(exchange.target, tokenWithDecimals);
    await transferTx.wait();

    // expect(await token.balanceOf(exchange.target)).to.eq(tokenWithDecimals);

    await expect(transferTx).to.changeTokenBalances(
      token, [owner, exchange], [-tokenWithDecimals, tokenWithDecimals]
    )

    const tokenBuy = 1n;
    const value = ethers.parseEther(tokenBuy.toString());

    const buyTx = exchange.connect(byuer).buy({ value: value });
    (await buyTx).wait();

    await expect(buyTx, "changeEtherBalances").to.changeEtherBalances(
      [byuer, exchange], [-value, value]
    )

    await expect(buyTx, "changeTokenBalances").to.changeTokenBalances(token,
      [exchange, byuer], [-value, value]
    )

  })

  it("Should allow to sell", async () => {
    const { byuer, token, exchange } = await loadFixture(deployTokenExchangeFixture);

    const ownerTokens = 2n;
    const transferTx = await token.transfer(byuer.address, await withDecimals(token, ownerTokens))
    await transferTx.wait();

    const topUpTx = await exchange.topUp({ value: ethers.parseEther("5") });
    await topUpTx.wait();

    const tokenToSell = 1n;
    const value = ethers.parseEther(tokenToSell.toString());

    const approveTx = await token.connect(byuer).approve(exchange.target, value);
    await approveTx.wait();

    const sellTx = await exchange.connect(byuer).sell(value);
    await sellTx.wait();

    await expect(sellTx, "changeEtherBalances").to.changeEtherBalances(
      [byuer, exchange], [value, -value]
    )

    await expect(sellTx, "changeTokenBalances").to.changeTokenBalances(token,
      [exchange, byuer], [value, -value]
    )
  })

  async function withDecimals(token: ExampleToken, value: bigint): Promise<bigint> {
    return value * 10n ** await token.decimals();
  }

})