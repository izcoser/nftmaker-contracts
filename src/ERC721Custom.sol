// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "forge-std/console.sol";

contract ERC721Custom is ERC721Enumerable, Ownable {
    struct FriendCollection {
        bytes32 merkleRoot;
        uint256 mintSlotsTotal;
        uint256 mintSlotsPerUser;
        uint256 mintPrice;
    }

    struct BasicInfo {
        bool publicMint;
        uint256 publicMintSlots;
        uint256 publicMintPrice;
        uint256 snapshotBlockNumber;
    }

    string private _uri;
    uint256 public maxSupply;

    //bytes32 public merkleRoot = bytes32(0);

    constructor(
        string memory name_,
        string memory symbol_,
        string memory uri_,
        uint256 maxSupply_,
        address owner_,
        BasicInfo memory basicInfo_,
        FriendCollection[] memory friendCollections
    ) ERC721(name_, symbol_) Ownable(owner_) {
        _uri = uri_;
        maxSupply = maxSupply_;
    }

    error ERC721CustomMaxSupplyReached(uint256 maxSupply_);
    error ERC721CustomInvalidProof(bytes32[] proof);

    function _baseURI() internal view override returns (string memory) {
        return _uri;
    }

    function setBaseUri(string memory uri_) external onlyOwner {
        _uri = uri_;
    }

    function mint() external {
        uint256 supply = totalSupply();
        if (supply == maxSupply) {
            revert ERC721CustomMaxSupplyReached(supply);
        }

        _safeMint(msg.sender, supply);
    }

    function mintWhiteList(
        bytes32[] memory proof,
        bytes32 merkleRoot,
        address account
    ) external {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account))));
        console.logBytes32(leaf);
        if (!MerkleProof.verify(proof, merkleRoot, leaf)) {
            revert ERC721CustomInvalidProof(proof);
        }

        _safeMint(msg.sender, totalSupply());
    }
}
