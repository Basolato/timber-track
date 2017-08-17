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
    var certificator_address = accounts[1];
    console.log("Central Authority deployed at address " + contract_address);


    //console.log(CentralAuthority)
    console.log("Account registered as certificator " + accounts[1])
    instance.registerCertificator(certificator_address, {from: accounts[0]});

    // check if verificators work
    instance.isValidCertificator.call(certificator_address, {from: accounts[0]}).then(function (response) {
      console.log("is the certificator validated? ")
      console.log(response)
    })

    Token.deployed().then(function () {

    })


})
