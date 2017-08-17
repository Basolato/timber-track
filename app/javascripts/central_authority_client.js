/* this file is run by the central authority */

// Require the contract
var jsonCA = require("../../build/contracts/CentralAuthority.json");
var jsonToken = require("../../build/contracts/TokenTemplate.json");
// Use also truffle-contract package
var contract = require("truffle-contract");
// Set up Web3
var Web3 = require('web3');
web3 = new Web3();

var CentralAuthority = contract(jsonCA);
var Token = contract(jsonToken);

var provider = new web3.providers.HttpProvider('http://localhost:8545');

web3.setProvider(provider);
CentralAuthority.setProvider(provider);
Token.setProvider(provider);

// Interact with the contract
var accounts = web3.eth.accounts;   // the list of accounts

CentralAuthority.deployed().then(function (instance) {


    var contract_address = instance.address;
    var certifier_address = accounts[1];
    var forest_manager = accounts[2];
    console.log("Central Authority deployed at address " + contract_address);


    //console.log(CentralAuthority)
    console.log("Account registered as certificator " + accounts[1])
    instance.registerCertificator(certifier_address, {from: accounts[0]});

    // check if verificators work
    instance.isValidCertificator.call(certifier_address, {from: accounts[0]}).then(function (response) {
      console.log("is the certificator validated? ")
      console.log(response)
    })
    var fake_address = accounts[0];

    Token.new(fake_address, fake_address, 'tree', {from: accounts[0],   gas: 4712388,
      gasPrice: 100000000000}).then(function(instance){
        instance.owner().then(function (r) {
          console.log(r)
        })
      })

    Token.new(accounts[5], fake_address, 'oak', {from: accounts[0],   gas: 4712388,
      gasPrice: 100000000000}).then(function(instance){
      instance.owner().then(function (r) {
        console.log(r)
      })
    })

    fee = {from: accounts[6], gas: 4712388, gasPrice: 100000000000}
    Token.createToken(10, fee);

  /**
    Token = new web3.eth.contract(jsonToken)
    console.log(Token)

    Token.deploy({data: jsonToken.unlinked_binary, arguments: [fake_address, fake_address, 'tree']})
      .send({from: accounts[0],
            gas: 1500000,
            gasPrice: 300000000000000}, function(e, c) {
              console.log(e,c)
      })

    instance.registerToken.call(accounts[0], fake_address, "Tree").then(function (response) {
      console.log("is the token created?")
      console.log(response)
      Token.at(response).then(function (response2) {

        console.log(response2)

      })
    })
  **/
    


})
