require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");

if (process.env.REPORT_GAS) {
  require('hardhat-gas-reporter');
}

if (process.env.REPORT_COVERAGE) {
  require('solidity-coverage');
}

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: '0.8.11',
    settings: {
      optimizer: {
        enabled: true,
        runs: 800,
      },
    },
  },
  gasReporter: {
    currency: 'USD',
    gasPrice: 100,
    showTimeSpent: true,
  },
  etherscan: {
    apiKey: {
      rinkeby: process.env.ETHERSCAN_API_KEY || '7V82CUY5725WJ4GIFHC7K8VVRR74FY1UGB',
      polygon: process.env.ETHERSCAN_API_KEY || 'R5ZKDYY8H2MX13S6Y648MJZCVHX2KWQ3KT',
      bsc: process.env.ETHERSCAN_API_KEY || 'IQTUHGGZEGHS1R9NZV97I3N8A16PWN9G9M',
    },
  },
  networks: {
    development: {
      url: "http://localhost:24012/rpc",
    },
    rinkeby: {
      url: "http://localhost:24012/rpc",
    },
    polygon: {
      url: "http://localhost:24012/rpc",
    },
    bsc: {
      url: "http://localhost:24012/rpc",
    }
  },
  plugins: ['solidity-coverage'],
};
