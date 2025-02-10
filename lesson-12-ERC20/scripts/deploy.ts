import { ethers, run } from "hardhat";

async function main() {
  console.log('Process deploing...')

  const [signer] = await ethers.getSigners();
  console.log("🚀 signer -> deploed:", signer)

  const ExampleTokenFactory = await ethers.getContractFactory('ExampleToken');
  const token = await ExampleTokenFactory.deploy(signer.address);
  await token.waitForDeployment()

  const TokenExchangeFactory = await ethers.getContractFactory('TokenExchange');
  const exchange = await TokenExchangeFactory.deploy(token.target);
  await exchange.waitForDeployment();

  const contractAddressToken = await exchange.getAddress();
  const contractAddressExchange = await exchange.getAddress();

  console.log(`Deployed Token to ${contractAddressToken}`);
  console.log(`Deployed Exchange to ${contractAddressExchange}`);

  // Verifying contract Token
  try {
    console.log("Verifying Token contract...");
    await run("verify:verify", {
      address: contractAddressToken,
      constructorArguments: [signer.address],
    });
    await run("verify:verify", {
      address: contractAddressExchange,
      constructorArguments: [token.target],
    });
    console.log("Verification Token successful!");
  } catch (error) {
    console.error("Verification Token failed:", error);
  }

  // Verifying contract Exchange
  try {
    console.log("Verifying Exchange contract...");
    await run("verify:verify", {
      address: contractAddressExchange,
      constructorArguments: [token.target],
    });
    console.log("Verification Exchange successful!");
  } catch (error) {
    console.error("Verification Exchange failed:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error); process.exit(1)
  })