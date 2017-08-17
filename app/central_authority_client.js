/* this file is run by the central authority */

// Require the contract
var jsonCA = require("../build/contracts/CentralAuthority.json");
// Use also truffle-contract package
var contract = require("truffle-contract");

// Set up Web3
var Web3 = require('web3');
web3 = new Web3();

var CentralAuthority = contract(jsonCA);
var provider = new web3.providers.HttpProvider('http://localhost:8545');

web3.setProvider(provider);
CentralAuthority.setProvider(provider);

// Interact with the contract
var accounts = web3.eth.accounts;   // the list of accounts

CentralAuthority.deployed().then(function (instance) {

    var contract_address = instance.address;
    console.log("Central Authority deployed at address " + contract_address);
    //console.log(CentralAuthority)
    console.log(accounts[1]);
    instance.registerCertificator(accounts[1]);

})
