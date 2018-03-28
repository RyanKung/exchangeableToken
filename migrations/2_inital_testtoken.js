var PremierToken = artifacts.require("./PremierToken.sol");

module.exports = function(deployer) {
    deployer.deploy(PremierToken, 'PremierToken', 'PMT', '8');
};
