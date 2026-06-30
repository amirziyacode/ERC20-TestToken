// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.30;


import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";



/**
 * @title ERC20 Token
 * @author AmirAli
 * @notice This contract is only for learning !!!
 */
contract TokenTest is ERC20,Ownable{

    error Invalid_Amount();
    error Zero_amount_ETH();
    error Not_Enough_Token();

    uint256 private constant TOTALSUPPLY = 1000000e18; 
    // 1ETH = 1000 TKT
    uint256 private constant RATE = 1000;  

    constructor() ERC20("TokenTest","TKT") Ownable(msg.sender){
        super._mint(msg.sender,TOTALSUPPLY);
    }


    // ################################
    //       External Function 
    //#################################

    /**
     * Mint Token just by the owner of this SmartContract.
     * @param _to recipient address for the minted tokens
     * @param _amount amount of tokens to mint
     */
    function mintToken(address _to,uint256 _amount) external onlyOwner{
        if (_amount == 0) revert Invalid_Amount();
        super._mint(_to,_amount);
    }

    /**
     * Burn Token 
     * @param _to recipient address for the minted tokens
     * @param _amount amount of tokens to burn
     */
    function burnToken(address _to,uint256 _amount) external {
        if (_amount == 0) revert Invalid_Amount();
        super._burn(_to,_amount);
    }


    /**
     * Shuld Buy token with ETH for exapmle we have one ETH and 
     * Should Give 1000 TKT Token !!
     * @param _to  the address of person want to buy TKT token
     * @notice send ETH is not zero !!
     * @notice the balance token of this smart contract is not lesser than amount person !!
     * @notice be carful is one testnet Sepolia
     */
    function buyToken(address _to) external payable{
        if(msg.value < 0){
            revert Zero_amount_ETH();
        }

        uint256 amount = msg.value * RATE;
        
        if(balanceOf(owner()) <= msg.value){
            revert Not_Enough_Token();
        }

        _transfer(owner(),_to,amount);

    }






}