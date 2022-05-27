
const hre = require("hardhat");

async function main() {
  const [owner] = await hre.ethers.getSigners();

  const CryptoRugsNFT = await hre.ethers.getContractFactory("CryptoRugsNFT");
  const cryptoRugsNFT = await CryptoRugsNFT.deploy(owner.address);

  await cryptoRugsNFT.deployed();

  console.log("CryptoRugsNFT deployed to:", cryptoRugsNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
