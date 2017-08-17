
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
        if (msg.sender == owner) {
            tokens.push(TokenTemplate(cAddress));
            return true;
        } else { return false; }
    }
    


    /* transform a certain quantity of a material
    in a new one, according to the exchange rate */
    function transform(uint NrExchangeRate, uint quantity) returns(uint){
        address user = msg.sender;
        ExchangeRate storage rate = rates[NrExchangeRate];
        //get TokenAmount
        uint tokenAmount = tokens[rate.inputToken].getBalance(user);
        
        //calculate what is maximum able to transform
        uint maxWithdrawal = tokenAmount / rate.inputFactor;
    
        //Define what he is actually to transform
        uint actualWithdrawal = 0;

        //Ensure that not more tokens are created than available from input token
        if(maxWithdrawal >= quantity) {
            actualWithdrawal = quantity;
        } else {
            actualWithdrawal = maxWithdrawal;
        }
        
        //Calculate actual Tokens that should be removed / added
        uint tokenRemoved = actualWithdrawal * rate.inputFactor;
        uint tokenCreated = actualWithdrawal * rate.outputFactor;
        
        tokens[rate.inputToken].modifyToken(user, -tokenRemoved);
        tokens[rate.outputToken].modifyToken(user, tokenCreated);
        
        
    }

    /* Only the central authority can modify the rates
    * @TODO
    * */
    function changeRate() {}
    
    function createRate(uint inputToken, uint inputFactor, uint outputToken, uint outputFactor)
    {
        ExchangeRate memory temp = ExchangeRate(inputToken, inputFactor, outputToken, outputFactor);
        rates.push(temp);
    }

}
