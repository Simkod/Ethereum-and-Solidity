// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(3);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 4);
    }

    function test_Decrement() public {
        counter.decrement();
        assertEq(counter.number(), 2);
    } 

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function testFuzz_integration(uint256 initialValue, uint8 incrementSteps, uint8 decrementSteps) public {        
        vm.assume(incrementSteps <= 10 && incrementSteps >= 1);
        vm.assume(decrementSteps <= 10 && decrementSteps >= 1);
        vm.assume(initialValue <= type(uint256).max - incrementSteps);
        vm.assume(initialValue + incrementSteps >= decrementSteps);

        counter.setNumber(initialValue);

        for(uint i = 0; i < incrementSteps; i++){
            counter.increment();
        }
        assertEq(counter.number(), initialValue + incrementSteps);

        uint256 postIncrementValue = initialValue + incrementSteps;

        for(uint i=0; i < decrementSteps; i++){
            counter.decrement();
        }
        assertEq(counter.number(), postIncrementValue - decrementSteps);
    }
    
}
