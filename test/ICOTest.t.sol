// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.30;


import {Test,console2} from "forge-std/Test.sol";
import {ICO} from "src/ICO.sol";
import{ERC20Mock} from "openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract tokenCoreTest is Test {
    ICO private tokenCore;
    ERC20Mock private token;
    
    address private owner = makeAddr("owner");
    address private user = makeAddr("user");


    uint256 constant FUNDING_AMOUNT = 5 ether;
    uint256 constant TOTALSUPPLY = 1000000e18;


    function setUp() public {
        token = new ERC20Mock(); 

        vm.prank(owner);

        tokenCore = new ICO(address(token));  

        token.mint(owner,TOTALSUPPLY);


        vm.deal(address(tokenCore),FUNDING_AMOUNT);
    }

    function testRevertWithDrawNotOwner() public {
        vm.prank(user);


        vm.expectRevert(ICO.Not_Owner_ICO.selector);

        tokenCore.withdraw();

    }

    function test_Withdraw_TransfersFullBalanceToOwner() public {
        uint256 ownerBalanceBefore = owner.balance;
        uint256 contractBalanceBefore = address(tokenCore).balance;

        vm.prank(owner);
        tokenCore.withdraw();

        assertEq(address(tokenCore).balance, 0, "contract balance should be zero after withdraw");
        assertEq(
            owner.balance,
            ownerBalanceBefore + contractBalanceBefore,
            "owner should receive full contract balance"
        );
    }


    function test_Withdraw_SucceedsWithZeroBalance() public {
        // drain contract first
        vm.prank(owner);
        tokenCore.withdraw();
        assertEq(address(tokenCore).balance, 0);

        // withdraw again, balance is 0
        vm.prank(owner);
        tokenCore.withdraw(); // should not revert
    }


    /// @notice If ETH transfer to owner fails, should revert with withdraw_ETH_Faild_ICO
    function test_Withdraw_RevertsIfETHTransferFails() public {
        // Deploy a contract as owner that rejects ETH (no receive/fallback)
        RejectETH rejecter = new RejectETH();

        vm.prank(address(rejecter));
        ICO ico2 = new ICO(address(token)); // if owner is set via constructor to msg.sender
        vm.deal(address(ico2), 1 ether);

        // If owner is immutable/set in constructor, you may need to deploy
        // ICO with `rejecter` as owner directly, e.g. via a constructor param
        // or by pranking as rejecter during deployment.

        vm.prank(address(rejecter));
        vm.expectRevert(ICO.withdraw_ETH_Faild_ICO.selector);
        ico2.withdraw();
    }


    function test_Revert_BuyToken_Zero_Amount() public {
        uint256 amount = 0;

        vm.prank(user);

        vm.expectRevert(ICO.Zero_amount_ETH_ICO.selector);
        tokenCore.buyToken{value:amount}();

    }

    function test_Revert_BuyToken_Not_Enough_Token() public{
        vm.deal(user, 100 ether);
        
        vm.prank(user);

        vm.expectRevert(ICO.Not_Enough_Token_ICO.selector);

        tokenCore.buyToken{value:100 ether}();

    }

    function test_BuyToken_Successfully() public {
        ICO ico = new ICO(address(token));


        uint256 sendValue = 1 ether;
        uint256 rate = 1000;
        uint256 peresion = 1e18;
        uint256 exactAmount = sendValue * rate * peresion;

        token.transfer(address(ico),exactAmount + 1);




        vm.prank(user);
        ico.buyToken{value:sendValue}();

        assertEq(token.balanceOf(user),exactAmount);
    }


    function testFuzz_Withdraw_AnyBalance(uint96 amount) public {
        vm.deal(address(tokenCore), amount);
        uint256 ownerBalanceBefore = owner.balance;


        vm.prank(owner);
        tokenCore.withdraw();


        assertEq(address(tokenCore).balance, 0);
        assertEq(owner.balance, ownerBalanceBefore + amount);
    }




    receive() external payable {}



}

/// @dev Helper contract with no receive/fallback — rejects plain ETH transfers
contract RejectETH {
    // Intentionally no receive() or fallback()
}