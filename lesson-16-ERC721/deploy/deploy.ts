import { ethers } from "hardhat";

async function main() {
  console.log('Process deploing...')

  const [signer] = await ethers.getSigners();

  const TokenFactory = await ethers.getContractFactory('Token');
  const token = await TokenFactory.deploy();
  await token.waitForDeployment()

  const contractAddress = await token.getAddress()

  console.log(`Deployed to ${contractAddress}`)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error); process.exit(1)
  })