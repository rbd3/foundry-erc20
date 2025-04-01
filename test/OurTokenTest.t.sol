// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    uint256 constant STARTING_BALANCE = 1000 ether;

    function setUp() external {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialeAllowance = 1000;

        //bob allow alice to spendtokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialeAllowance);

        uint256 transferAmout = 500;
        vm.prank(alice);

        ourToken.transferFrom(bob, alice, transferAmout);

        assertEq(ourToken.balanceOf(alice), transferAmout);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmout);
    }

    // Transfer tests
    function testTransfer() public {
        uint256 transferAmount = 100 ether;

        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testAllowanceCanBeUpdated() public {
        uint256 initialAllowance = 1000;
        uint256 updatedAllowance = 500;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        assertEq(ourToken.allowance(bob, alice), initialAllowance);

        vm.prank(bob);
        ourToken.approve(alice, updatedAllowance);
        assertEq(ourToken.allowance(bob, alice), updatedAllowance);
    }
}
