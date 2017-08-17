
/**
 * The exchange contains predefined transactions to modify the material
 * and therefore exchange the associated tokens.
 */

pragma solidity ^0.4.8;

import "./TokenTemplate.sol";

contract Exchange {
    
    //an easy version of an Exchange rate which only supports one input and one output
    struct ExchangeRate {
        uint inputToken;
        uint inputFactor;
        
        uint outputToken;
        uint outputFactor;
    }
    
    address public owner;
    TokenTemplate [] public tokens;

    ExchangeRate [] public rates;
    
    /* called only once at initialization */
    function Exchange(address newOwner) {
        owner = newOwner;
    }
    
    //Thats a function only called from the owner, that said the CA, as the Exchange should have access
    //To the exact same tokens
    function registerToken(address cAddress) returns(bool) {
        if (msg.sender != owner) {
            tokens.push(TokenTemplate(cAddress));
            return true;
        } else { return false; }
    }
    


    /* transform a certain quantity of a material
    in a new one, according to the exchange rate */
    //function transform(uint NrExchangeRate, uint quantity) {
        //address user = msg.sender;
        //ExchangeRate rate = rates[NrExchangeRate];
        //get TokenAmount
        //uint tokenAmount = tokens[rate.inputToken].getBalance(user);
        
        //We first have to check how much coins are available to convert
        


        //uint rate;

        //if ((iToken ==TREE_ID)&&(oToken==COAL_ID)) {
        //    rate = rateTreeCoal;
        //} else {
        //    rate = rateTreePlank;
        //}

        // security checks
        // @TODO

        // delete the input token quantity
        //owner = msg.sender;
        //coins[iToken].modifyToken(owner, -quantity);

        // create the output token
        //uint oTokenQuantity = rate*quantity/100;
        //coins[oToken].modifyToken(owner, oTokenQuantity);
    //}

    /* Only the central authority can modify the rates
    * @TODO
    * */
    function changeRate() {}

}
