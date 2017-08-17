/**
 * The Central Authority can initialize tokens and authorize coniators.
 * It also registers and modifies exchanges.
 */

pragma solidity ^0.4.8;

contract CentralAuthority {

    address public owner;
    address public exchange;
    mapping(address => bool) allowedCertificator;
    mapping(address => bool) allowedParticipants;
    mapping(address => bool) tokens;

    //comment ug: I am actually not quite sure if we should do
    //it with some kind of mapping or with an array, as we are not able to go
    // with a foreach over an mapping, but we can check easily if it a
    // value is contained in there
    // certifiers
    //address[] authorizedConiators;
    //uint nConiators;

    function CentralAuthority() {
        owner = msg.sender;
    }

    function registerExchange(address newExchange) {
        if (msg.sender == owner)
            exchange = newExchange;
    }

    function registerCertificator(address newCertificator) returns(bool) {
        if(msg.sender == owner){
            allowedCertificator[newCertificator] = true;
            return true;
        } else { return false; }
    }

    function registerParticipant(address newParticiant) returns(bool) {
        if(msg.sender == owner){
            allowedParticipants[newParticiant] = true;
            return true;
        } else { return false; }
    }

    function registerToken(address newToken) returns(bool) {
        if(msg.sender == owner) {
            tokens[newToken] = true;
            return true;
        } else { return false; }
    }

    //function issueNewIssuerAtToken(address TokenAddress, address issuer) returns(bool)
    //{

    //}

    function isValidCertificator(address certificator) returns(bool){
        return allowedCertificator[certificator];
    }

    function isValidParticipant(address participant) returns(bool){
        return allowedParticipants[participant];
    }

    function isValidToken(address tokenAddress) returns(bool){
        return tokens[tokenAddress];
    }

}
