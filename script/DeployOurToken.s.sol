// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {OurToken} from "src/OurToken.sol";

contract DeployOurToken is Script {
    uint256 public constant INITIAL_SSUPPLY = 1000 ether;

    function run() external returns (OurToken) {
        vm.startBroadcast();
        OurToken ot = new OurToken(INITIAL_SSUPPLY);
        vm.stopBroadcast();
        return ot;
    }
}
