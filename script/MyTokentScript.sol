// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Script,console2} from "forge-std/Script.sol";
import {MyTokenTest} from "src/MyTokenTest.sol";
import {ICO} from 'src/ICO.sol';
import {IERC20} from "openzeppelin-contracts/contracts/interfaces/IERC20.sol";



contract MyTokentScript is Script {
    MyTokenTest public myTokenTest;
    ICO public ico;


    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        myTokenTest = new MyTokenTest();
        ico = new ICO(msg.sender);

        console2.log("Token deployed at:", address(myTokenTest));

        vm.stopBroadcast();
    }
}
