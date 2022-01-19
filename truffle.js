const HDWalletProvider = require('truffle-hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      sender: "0xa18dd975b55a9592fa57d17bce502aff06d0e010", // default address to use for any transaction Truffle makes during migrations
      network_id: 4,
      gas: 4612388 // Gas limit used for deploys
    },
    live: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0xf3e1e474219a9789e5d59d0331ade8b777a5be96",
      network_id: '1',
      gasPrice: 75000000000,
      gas: 5721975
    },
    testnet: {
      provider: () => {
        const data = new HDWalletProvider(mnemonic, `https://data-seed-prebsc-2-s3.binance.org:8545/`, 0, 100);
        return data
      },
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      from: "0xD8f3234C711Dd16ee0d881659d6502161999806d",
      skipDryRun: true
    },
    bsc: {
      provider: () => new HDWalletProvider(mnemonic, `https://bsc-dataseed2.ninicoin.io/`),
      network_id: 56,
      confirmations: 10,
      from: "0xC8b456bd249854027eFB190f312812af3c5d9f8A",
      sender: "0xC8b456bd249854027eFB190f312812af3c5d9f8A", // default address to use for any transaction Truffle makes during migrations
      timeoutBlocks: 200,
      skipDryRun: true
    },
  }
};