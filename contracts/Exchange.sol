
/**
 * The exchange contains predefined transactions to modify the material
 * and therefore exchange the associated tokens.
 */

pragma solidity ^0.4.8;

import "./TokenTemplate.sol";

contract Exchange {

    uint rateTreePlank = 10;
    uint rateTreeCoal = 50;

    uint TREE_ID = 1;
    uint COAL_ID = 2;
    uint PLANK_ID = 3;

    address owner;
    TokenTemplate [] coins;

    /* called only once at initialization */
    function Exchange() {

    }

    function registerCoin(address cAddress) {

        //if (msg.sender != owner)
        //    assert(0);

        coins.push(TokenTemplate(cAddress));
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

