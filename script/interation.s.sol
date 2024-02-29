// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract interactstuff is Script {
    uint256 public send_value = 0.01 ether;
    function fundfundme(address recentcontract) public{
        vm.startBroadcast();
        FundMe(payable(recentcontract)).fund{value:send_value}();
        vm.stopBroadcast();
    }
    function run() public {
        address recentcontract = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        fundfundme(recentcontract);
    }

}

contract interactstuffwithdraw is Script {
    uint256 public send_value = 0.01 ether;
    function withdrawfund(address recentcontract) public{
        vm.startBroadcast();
        FundMe(payable(recentcontract)).withdraw();
        vm.stopBroadcast();
    }
    function run() external {
        address recentcontract = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        withdrawfund(recentcontract);
    }

}