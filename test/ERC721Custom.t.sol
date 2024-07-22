// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC721Custom} from "../src/ERC721Custom.sol";

contract ERC721CustomTest is Test {
    ERC721Custom public erc721Custom;
    address public owner = address(uint160(uint256(1)));
    address public notInList = address(uint160(uint256(5)));
    // Merkle Root of tree with address values: [ ["0x...01"], ["0x...02"] ]
    bytes32 public merkleRoot =
        0xe685571b7e25a4a0391fb8daa09dc8d3fbb3382504525f89a2334fbbf8f8e92c;
    bytes32[] public proofOwnerIsInTree;

    ERC721Custom.BasicInfo basicInfo =
        ERC721Custom.BasicInfo({
            publicMint: true,
            publicMintPrice: 1 ether,
            publicMintSlots: 10000,
            snapshotBlockNumber: 0
        });

    ERC721Custom.FriendCollection[] friendCollections;
    ERC721Custom.FriendCollection fc =
        ERC721Custom.FriendCollection({
            merkleRoot: merkleRoot,
            mintSlotsTotal: 20,
            mintSlotsPerUser: 1,
            mintPrice: 1 wei
        });

    function setUp() public {
        friendCollections.push(fc);
        erc721Custom = new ERC721Custom(
            "Test NFT",
            "TEST",
            "dummy_uri",
            2,
            owner,
            basicInfo,
            friendCollections
        );
        proofOwnerIsInTree.push(
            0x1ab0c6948a275349ae45a06aad66a8bd65ac18074615d53676c09b67809099e0
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

    function test_mintWhitelist() public {
        vm.startPrank(owner);
        erc721Custom.mintWhiteList(proofOwnerIsInTree, merkleRoot, owner);
    }

    function testFail_mintWhitelistNotInList() public {
        vm.startPrank(notInList);
        erc721Custom.mintWhiteList(proofOwnerIsInTree, merkleRoot, notInList);
    }
}
