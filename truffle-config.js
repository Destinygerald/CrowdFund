require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {


  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 8545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },
    
    
    sepolia: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, `wss://eth-sepolia.g.alchemy.com/v2/${process.env.PROJECT_ID}`),
      network_id: 11155111,
      confirmations: 2,    
      timeoutBlocks: 200,  
      skipDryRun: true,    
      gas: 5500000,
      gasPrice:15000000000,
      networkCheckTimeout: 10000
    },
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
     timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.19",      // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
       optimizer: {
         enabled: false,
         runs: 200
       },
      //  evmVersion: "byzantium"
       }
    }
  },

  
  // db: {
  //   enabled: false,
  //   host: "127.0.0.1",
  //   adapter: {
  //     name: "indexeddb",
  //     settings: {
  //       directory: ".db"
  //     }
  //   }
  // }
};
