
pragma solidity ^0.4.8;

import "./CentralAuthority.sol";

/**
 * The TimberCoin is a generic token that represents the amount of certified object,
 * that is wood under the form of tree, coal, plank.
 */
contract TokenTemplate {

    //Basic definitions:
    //  Owner(Connection to the CA)
    //  Exchange(Connection to the Exchange)
    //  Name of the Token
    address public owner;
    address public exchange;
    string public name;

    mapping (address => bool) allowedIssuers;
    mapping (address => uint) balances;

    function TokenTemplate(address newowner, address newexchange, string newname){
        owner = newowner;
        exchange = newexchange;
        name = newname;
    }

    function setIssuer(address newIssuer) returns(bool){
        if(msg.sender == owner)
        {
            allowedIssuers[newIssuer] = true;
            return true;
        } else { return false; }

    }

    function createToken(uint amount) returns(bool){
        if(isValidIssuer(msg.sender))
        {
            balances[msg.sender] = balances[msg.sender] + amount;
            return true;
        }
        else { return false; }
    }

    function isValidIssuer(address issuer) returns(bool){
        return allowedIssuers[issuer];
    }

    function send(address receiver, uint amount) returns(bool sufficient){
        if (balances[msg.sender] < amount) return false;

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        //Transfer(msg.sender, receiver, amount);
        return true;
    }
    

    function getBalance(address addr) returns(uint){
        return balances[addr];
    }

    //Only function for the Exchange to manipulate Tokens
    function modifyToken(address account, uint amount) returns(bool){
        uint testcalc = balances[account] + amount;
        if(msg.sender == exchange && testcalc >= 0) {
            balances[account] += amount;
        } else { return false; }
    }

}