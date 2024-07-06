// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {ERC721Custom} from "../src/ERC721Custom.sol";

contract ERC721CustomTest is Test {
    ERC721Custom public erc721Custom;
    address public owner = address(uint160(uint256(1)));

    function setUp() public {
        erc721Custom = new ERC721Custom(
            "Test NFT",
            "TEST",
            "dummy_uri",
            2,
            owner
        );
    }

    function test_totalSupply() public view {
        assertEq(erc721Custom.totalSupply(), 0);
    }

    function test_mint() public {
        vm.prank(owner);
        erc721Custom.mint();
        assertEq(erc721Custom.totalSupply(), 1);
        assertEq(erc721Custom.balanceOf(owner), 1);
    }

    function testFail_mintMoreThanMaxSupply() public {
        vm.startPrank(owner);
        erc721Custom.mint();
        erc721Custom.mint();
        erc721Custom.mint();
        vm.stopPrank();
    }
}
