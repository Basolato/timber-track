pragma solidity ^0.4.4;

import "./ConvertLib.sol";

pragma solidity ^0.4.8;


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
    function destroyToken(address account, uint amount) returns(bool){
        if(msg.sender == exchange && amount <= balances[account])
        {
            balances[account] = balances[account] - amount;
        } else { return false; }
    }
    
    function getBalance(address addr) returns(uint){
            return balances[addr];
    }
    
    function modifyToken(address account, uint amount) returns(bool){
        if(msg.sender == exchange && amount >= 0)
        {
            balances[account] = amount;
        } else { return false; }
    }
    
    
    
}

/**
 * The exchange contains predefined transactions to modify the material
 * and therefore exchange the associated tokens.
 */
contract Exchange {

    uint rateTreePlank = 10;
    uint rateTreeCoal = 50;

    uint TREE_ID = 1;
    uint COAL_ID = 2;
    uint PLANK_ID = 3;
    address owner;
    TimberCoin [] coins;

    /* called only once at initialization */
    function Exchange() {

    }

    function registerCoin(address cAddress) {

        //if (msg.sender != owner)
        //    assert(0);

        coins.push(TimberCoin(cAddress));
    }

    /* transform a certain quantity of a material
    in a new one, according to the exchange rate */
    function transform(uint iToken, uint quantity, uint oToken) {

        uint rate;

        if ((iToken ==TREE_ID)&&(oToken==COAL_ID)) {
            rate = rateTreeCoal;
        } else {
            rate = rateTreePlank;
        }

        // security checks
        // @TODO

        // delete the input token quantity
        owner = msg.sender;
        coins[iToken].modifyToken(owner, -quantity);

        // create the output token
        uint oTokenQuantity = rate*quantity/100;
        coins[oToken].modifyToken(owner, oTokenQuantity);
    }

    /* Only the central authority can modify the rates
    * @TODO
    * */
    function changeRate() {}

}

/**
 * The Central Authority can initialize tokens and authorize coniators.
 * It also registers and modifies exchanges.
 */
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

    function CentralAuthority(address newOwner, address newExchange) {
        owner = newOwner;
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
    
    function issueNewIssuerAtToken(address TokenAddress, address issuer) returns(bool)
    {
        
    }

    function isValidCertificator(address certificator) returns(bool){
        return allowedCertificator[certificator];
    }
    
    function isValidParticipant(address participant) returns(bool){
        return allowedParticipants[participant];
    }
    
    function isValidToken(address Token) returns(bool){
        return tokens[Token];
    }

}