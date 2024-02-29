// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundme.sol";
import {deployfundme} from "../script/fundme.s.sol";
import {interactstuff,interactstuffwithdraw} from "../script/interation.s.sol";

contract fundmeintegration is Test{

    FundMe newfund;
    uint256 constant public funding_value = 0.1 ether;
    uint256 constant public starting_value = 10 ether;
    address user = makeAddr("user");
    function setUp() external 
    {

        deployfundme deployfund = new deployfundme();
        newfund = deployfund.run();
        vm.deal(user,starting_value);
    }

    function testusercansend() external {
        interactstuff fund_contract = new interactstuff();
        fund_contract.fundfundme(address(newfund));

        
        interactstuffwithdraw with_drawcontracts = new interactstuffwithdraw();
        with_drawcontracts.withdrawfund(address(newfund));

        assert(address(newfund).balance ==0);
    }
}


