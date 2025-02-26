require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.19",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337, // Ensures consistency across test runs
      allowUnlimitedContractSize: true, // Avoids out-of-gas issues
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 20000, // Increases test timeout (optional)
  },
};