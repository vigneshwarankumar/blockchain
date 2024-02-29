// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {MockV3Aggregator} from "../src/mockaggregator.sol";

contract helperconfing is Script{
    uint8 public constant decimal = 8;
    int256 public constant answer = 2000e8;
    struct Networkconfig{
        address pricefeed;
    }

    Networkconfig public activenetworkconfig;
    
    constructor(){
    if(block.chainid == 11155111){
        activenetworkconfig = getsepoliaETHconfig();
    }
    else if (block.chainid == 1)
    {
        activenetworkconfig = getethereumconfig();
    }
    else{
        activenetworkconfig = getorcreateanvilconfig();
    }
    }

    function getsepoliaETHconfig() public pure returns(Networkconfig memory) {
    Networkconfig memory sepoliaconfig = Networkconfig({
        pricefeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
    }) ;
    return sepoliaconfig;
    }
    function getethereumconfig() public pure returns(Networkconfig memory){
    Networkconfig memory ethconfig = Networkconfig({
        pricefeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
    }) ;
    return ethconfig;
    }

    function getorcreateanvilconfig() public returns(Networkconfig memory) {
    //saying if activenetworkconfig already has network address then use it for network 
    if(activenetworkconfig.pricefeed != address(0)){
        return activenetworkconfig;
    }
    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(decimal,answer);
    vm.stopBroadcast();

    Networkconfig memory anvilconfig = Networkconfig({pricefeed:address(mockPriceFeed)});

    return anvilconfig;
    }
}