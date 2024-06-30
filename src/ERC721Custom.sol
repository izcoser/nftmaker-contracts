// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Custom is ERC721, Ownable {
    string private _uri;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory uri_,
        address owner_
    ) ERC721(name_, symbol_) Ownable(owner_) {
        _uri = uri_;
    }

    function _baseURI() internal view override returns (string memory) {
        return _uri;
    }

    function setBaseUri(string memory uri_) external onlyOwner{
        _uri = uri_;
    }

    
}
