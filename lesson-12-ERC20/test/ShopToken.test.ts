import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { ExampleToken } from "../typechain-types";

describe("ShopToken", () => {
  async function deployShopTokenFixture() {
    const [owner, byuer] = await ethers.getSigners();

    const ExampleTokenFactory = await ethers.getContractFactory('ExampleToken');
    const token = await ExampleTokenFactory.deploy(owner.address);
    await token.waitForDeployment();

    const ShopTokenFactory = await ethers.getContractFactory('ShopToken');
    const shop = await ShopTokenFactory.deploy(token.target);
    await shop.waitForDeployment();

    return { owner, byuer, token, shop };
  }

  it("Should allow to buy", async () => {
    const { owner, byuer, token, shop } = await loadFixture(deployShopTokenFixture);

    const tokenInStock = 3n;
    const tokenWithDecimals = await withDecimals(token, tokenInStock);

    const transferTx = await token.transfer(byuer.address, tokenWithDecimals);
    await transferTx.wait();

    const price = 1000n;
    const quantity = 5;
    const name = 'test';

    const addTx = await shop.addItem(price, quantity, name);
    await addTx.wait();

    const uid = await shop.uniqueIds(0);
    const deliveryAddress = 'some address';
    const quantityByer = 2n;
    const totalPrice = quantityByer * price;

    const approveTx = await token.connect(byuer).approve(shop.target, totalPrice);
    await approveTx.wait();

    const buyTx = await shop.connect(byuer).buy(uid, quantityByer, deliveryAddress);
    await buyTx.wait();

    await expect(buyTx, "changeTokenBalances").to.changeTokenBalances(token,
      [shop, byuer], [totalPrice, -totalPrice]
    )

    expect(await token.allowance(byuer.address, shop.target)).to.eq(0);

    const boughtItem = await shop.buyers(byuer.address, 0)

    expect(boughtItem.deliveryAddress).to.eq(deliveryAddress);
    expect(boughtItem.uniqueld).to.eq(uid);
    expect(boughtItem.numOfPurchasedItems).to.eq(quantityByer);
  })


  async function withDecimals(token: ExampleToken, value: bigint): Promise<bigint> {
    return value * 10n ** await token.decimals();
  }


})