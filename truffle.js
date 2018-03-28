require('babel-register');
require('babel-polyfill');

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
    // for more about customizing your Truffle configuration!
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    },
    networks: {
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*", // Match any network id,
            from: '0x627306090abaB3A6e1400e9345bC60c78a8BEf57',
        }
    }
};
