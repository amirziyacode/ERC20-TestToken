// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.30;

import {IERC20} from "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

contract ICO {
    error Zero_amount_ETH_ICO();
    error Not_Enough_Token_ICO();
    error Transfer_Token_Faild_ICO();
    error Not_Owner_ICO();
    error withdraw_ETH_Faild_ICO();

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 paid);

    IERC20 public token;
    address public owner;

    uint256 private constant RATE = 1000;
    uint256 private constant PERESION = 1e18;

    constructor(address _token) {
        token = IERC20(_token);
        owner = msg.sender;
    }

    /**
     * Shuld Buy token with ETH for exapmle we have one ETH and
     * Should Give 1000 TKT Token !!
     * @notice send ETH is not zero !!
     * @notice the balance token of this smart contract is not lesser than amount person !!
     * @notice be carful is one testnet Sepolia
     */
    function buyToken() external payable {
        if (msg.value == 0) {
            revert Zero_amount_ETH_ICO();
        }

        uint256 amount = msg.value * RATE * PERESION;

        if (token.balanceOf(address(this)) <= amount) {
            revert Not_Enough_Token_ICO();
        }

        bool success = token.transfer(msg.sender, amount);
        if (!success) {
            revert Transfer_Token_Faild_ICO();
        }

        emit TokensPurchased(msg.sender, amount, msg.value);
    }

    /**
     * @notice the owner of contract can withdraw all ETH
     */
    function withdraw() external {
        if (msg.sender != owner) {
            revert Not_Owner_ICO();
        }
        uint256 balance = address(this).balance;

        (bool success,) = payable(owner).call{value: balance}("");
        if (!success) {
            revert withdraw_ETH_Faild_ICO();
        }
    }
}
