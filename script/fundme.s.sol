// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {helperconfing} from "./helpconfig.s.sol";

contract deployfundme is Script {


    function run() public returns(FundMe) {
        helperconfing config = new helperconfing();
        (address pricefeed) = config.activenetworkconfig(); 
        vm.startBroadcast();
        FundMe newfund = new FundMe(pricefeed);
        vm.stopBroadcast();
        return newfund;
    }
}
