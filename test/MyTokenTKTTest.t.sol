// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.30;


import {Test,console2} from "forge-std/Test.sol";
import {MyTokenTest} from "src/MyTokenTest.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC20Mock} from "openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract MyTokenTKTTest is Test{
    MyTokenTest public myTokenTest;
    ERC20Mock public erc20Mock;

    uint256 private constant TOTALSUPPLY = 1000;


    address private owner = makeAddr("owner");
    address private  user = makeAddr("user");


    function setUp()  public  {
        erc20Mock = new ERC20Mock();
        myTokenTest = new MyTokenTest();
    }


    function testShouldOwnerMintToken() public{



        vm.startPrank(owner);
        myTokenTest = new MyTokenTest();

        myTokenTest.mintToken(user,TOTALSUPPLY);

        uint256 balance =  myTokenTest.balanceOf(user);
        


        assertEq(balance ,TOTALSUPPLY);


        vm.stopPrank();
    }

    function test_Should_revert_when_user_call_mintToken() public {
        vm.startPrank(user);

        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                user
            )
        );

        myTokenTest.mintToken(user, TOTALSUPPLY);

        vm.stopPrank();
    }

    function testburnToken() public {

        vm.startPrank(user);

        myTokenTest = new MyTokenTest(); 

        myTokenTest.mintToken(user,TOTALSUPPLY);

        myTokenTest.burnToken(100);

        uint256 excpectBalance = 1000000000000000000000900;

        uint256 actualBalance = myTokenTest.balanceOf(user);


        assertEq(actualBalance,excpectBalance);


        vm.stopPrank();
    }
}