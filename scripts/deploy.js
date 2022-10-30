// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat');

async function main() {
  const Library = await hre.ethers.getContractFactory('Library');
  const library = await Library.deploy();

 await library.deployed();

 console.log(`Contract is deployed to ${library.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
 main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});

//const ALCHEMY_API_KEY = "g_pw19NjfqwAY_R-r4l3-smaQFMNYi4I";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
//const GOERLI_PRIVATE_KEY = "af8e171fceeee3d5e1e5d9076a973e36e874db89c8666d601ac2b48bd4650fcd";

//module.exports = {
  // ...rest of your config...
//  networks: {
 //   goerli: {
///      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
 //     accounts: [GOERLI_PRIVATE_KEY],
  //  },
 // },
//};
