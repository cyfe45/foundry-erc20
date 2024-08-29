// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.sol";

contract OurTokenTest is Test {
    DeployOurToken public deployer;
    OurToken public ourToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant INITIAL_SUPPLY = 100 ether;
    uint256 public constant STARTING_BALANCE = 10 ether;

    // setUp: Initializes the test environment by deploying the token contract and setting up initial balances.
    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    // testInitialSupply: Tests the initial supply of the token to ensure it is correctly set.
    function test_initialSupply() public view {
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY);
    }

    // testNameAndSymbol: Tests the name and symbol of the token to ensure they are correctly set.
    function testNameAndSymbol() public view {
        assertEq(ourToken.name(), "OurToken");
        assertEq(ourToken.symbol(), "OT");
    }

    // testBobBalance: Tests Bob's balance to ensure it is correctly set.
    function testBobBalance() public view {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    // testAliceBalance: Tests Alice's balance to ensure it is correctly set.
    function testAliceBalance() public view {
        assertEq(ourToken.balanceOf(alice), 0);
    }

    // testTransfer: Tests the transfer function to ensure it correctly transfers tokens from one address to another.
    function testTransfer() public {
        vm.prank(bob);
        ourToken.transfer(alice, 10 ether);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - 10 ether);
        assertEq(ourToken.balanceOf(alice), 10 ether);
    }

    // testAllowanceWorks: Tests the allowance functionality to ensure it correctly tracks token transfers.
    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.allowance(bob, alice), initialAllowance - transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

    function test_mint() public {
        uint256 amountToMint = 1000 ether;
        ourToken.mint(alice, amountToMint);
        assertEq(ourToken.balanceOf(alice), amountToMint);
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY + amountToMint);
    }

    function test_burn() public {
        uint256 amountToBurn = 5 ether;
        vm.prank(bob);
        ourToken.burn(amountToBurn);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - amountToBurn);
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY - amountToBurn);
    }

    function test_approveAndTransferFrom() public {
        uint256 approvalAmount = 5 ether;
        vm.prank(bob);
        ourToken.approve(alice, approvalAmount);
        assertEq(ourToken.allowance(bob, alice), approvalAmount);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, approvalAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - approvalAmount);
        assertEq(ourToken.balanceOf(alice), approvalAmount);
    }

    // testInitialSupply: Checks if the initial supply is correctly minted to the contract deployer.
    function testInitialSupply() public {
        uint256 initialSupply = 1000000 * 10**18; // Assuming 18 decimals
        OurToken token = new OurToken(initialSupply);
        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(address(this)), initialSupply);
    }

    // testMint: Tests the mint function to ensure it correctly mints tokens to a recipient.
    function testMint() public {
        OurToken token = new OurToken(0);
        uint256 amount = 1000 * 10**18;
        address recipient = address(0x123);
        token.mint(recipient, amount);
        assertEq(token.balanceOf(recipient), amount);
        assertEq(token.totalSupply(), amount);
    }

    // testBurn: Tests the burn function to ensure it correctly burns tokens from the caller.
    function testBurn() public {
        OurToken token = new OurToken(1000 * 10**18);
        uint256 amount = 500 * 10**18;
        address recipient = address(0x123);
        token.mint(recipient, amount);
        assertEq(token.balanceOf(recipient), amount);
        token.burn(amount);
    }

    // testFailMintToZeroAddress: Tests that minting to a zero address fails.
    function testFailMintToZeroAddress() public {
        OurToken token = new OurToken(0);
        token.mint(address(0), 1000);
    }

    // testFailBurnMoreThanBalance: Tests that burning more tokens than the balance fails.
    function testFailBurnMoreThanBalance() public {
        uint256 initialSupply = 1000 * 10**18;
        OurToken token = new OurToken(initialSupply);
        token.burn(initialSupply + 1);
    }

    function testBalanceAfterTransfer() public {
        uint256 amount = 1000;
        address receiver = address (0x1);
        uint256 initialBalance = ourToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(msg.sender), initialBalance - amount);
    }
}