// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.30;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ERC20 Token
 * @author AmirAli
 * @notice This contract is only for learning !!!
 */
contract MyTokenTest is ERC20, Ownable {

    uint256 private constant TOTALSUPPLY = 1000000e18;
    // 1ETH = 1000 TKT

    constructor() ERC20("TokenTest", "TKT") Ownable(msg.sender) {
        super._mint(msg.sender, TOTALSUPPLY);
    }

    // ################################
    //       External Function
    //#################################

    /**
     * Mint Token just by the owner of this SmartContract.
     * @param _to recipient address for the minted tokens
     * @param _amount amount of tokens to mint
     */
    function mintToken(address _to, uint256 _amount) external onlyOwner {
        super._mint(_to, _amount);
    }

    /**
     * Burn Token
     * @param _amount amount of tokens to burn
     */
    function burnToken(uint256 _amount) external {
        super._burn(msg.sender, _amount);
    }
}
