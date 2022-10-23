require("@nomicfoundation/hardhat-toolbox");
require('solidity-coverage');

const ALCHEMY_API_KEY = "TOh9OCIQMa1Xm_LRKPIE617_AD_PXpta";
const GOERLI_PRIVATE_KEY = "af8e171fceeee3d5e1e5d9076a973e36e874db89c8666d601ac2b48bd4650fcd";


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  etherscan: {
    apiKey: "HJ94N4FRFEVQYITPB4W2J19M9BQPXMZS6M",
  },
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
    },
  },
};

