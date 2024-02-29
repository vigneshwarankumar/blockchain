// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundme.sol";
import {deployfundme} from "../script/fundme.s.sol";

contract fundme is Test{

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
    function testowner() public
    {
  //      console.log(newfund.MINIMUM_USD());
  //      console.log(msg.send));
        assertEq(newfund.i_owner(),msg.sender);
    }

    function testversion() public 
    {
        console.log(block.timestamp);
        assertEq(newfund.getVersion(),4);

    }

    function checkfundme() public {
        vm.expectRevert();
        newfund.fund();
    }

    function testchectbalanceeth() public {
        vm.prank(user);
        newfund.fund{value:funding_value}();
        console.log(address(newfund).balance);
        uint256 amountfunded = newfund.getAddressToAmountFunded(user);
        assertEq(funding_value,amountfunded);
    }

    modifier funded() {
    vm.prank(user);
    newfund.fund{value:funding_value}();
    _;
    }

    function testaddfundertothearray() public funded{
        address funder = newfund.getFunder(0);
        assertEq(funder,user);
    }

    function testownerwithdraw() external funded{
        vm.prank(user);
        vm.expectRevert();
        newfund.withdraw();
    }

    function testwithdrawsinglefunder() external funded{
        uint256 starting_owner_b = newfund.getOwner().balance;
        uint256 starting_funder_b = address(newfund).balance;
        console.log(starting_owner_b);
        console.log(starting_funder_b);
        vm.prank(newfund.getOwner());
        newfund.withdraw(); 

        
        uint256 end_owner_b = newfund.getOwner().balance;
        uint256 end_funder_b = address(newfund).balance;

        console.log(end_owner_b);
        console.log(end_funder_b);
        assertEq(end_funder_b,0);
        assertEq(starting_owner_b+starting_funder_b,end_owner_b);
    }

    function testmultiplefunder() external funded {
    uint160 numberoffunder = 10;
    uint160 startingfunderindex = 1;
    for(uint160 i = startingfunderindex;i<numberoffunder;i++)
    {
        hoax(address(i),funding_value);
        newfund.fund{value:funding_value}();
    }

    uint256 starting_owner_b = newfund.getOwner().balance;
    uint256 starting_funder_b = address(newfund).balance;

      vm.prank(newfund.getOwner());
      newfund.withdraw(); 

        
    uint256 end_owner_b = newfund.getOwner().balance;
    uint256 end_funder_b = address(newfund).balance;

    console.log(end_owner_b);
    console.log(end_funder_b);
    assertEq(end_funder_b,0);
    assertEq(starting_owner_b+starting_funder_b,end_owner_b);

    }

    function testcheaperfunder() external funded {
    uint160 numberoffunder = 10;
    uint160 startingfunderindex = 1;
    for(uint160 i = startingfunderindex;i<numberoffunder;i++)
    {
        hoax(address(i),funding_value);
        newfund.fund{value:funding_value}();
    }

    uint256 starting_owner_b = newfund.getOwner().balance;
    uint256 starting_funder_b = address(newfund).balance;

      vm.prank(newfund.getOwner());
      newfund.cheaperWithdraw(); 

        
    uint256 end_owner_b = newfund.getOwner().balance;
    uint256 end_funder_b = address(newfund).balance;

    console.log(end_owner_b);
    console.log(end_funder_b);
    assertEq(end_funder_b,0);
    assertEq(starting_owner_b+starting_funder_b,end_owner_b);

    }

    
}