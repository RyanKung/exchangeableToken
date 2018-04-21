var TestToken = artifacts.require("./ERC20/TestToken.sol");

module.exports = function(deployer) {
    deployer.deploy(TestToken, 'TestToken', 'TST', '8');
};
