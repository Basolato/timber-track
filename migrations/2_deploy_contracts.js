var ConvertLib = artifacts.require("./ConvertLib.sol");
var CentralAuth = artifacts.require("./CentralAuthority.sol");
var Tokens = artifacts.require("./TokenTemplate.sol");
var Exchange = artifacts.require("./Exchange.sol");

module.exports = function(deployer) {
    deployer.deploy(CentralAuth);
    deployer.deploy(Tokens);
    deployer.deploy(Exchange);
};
