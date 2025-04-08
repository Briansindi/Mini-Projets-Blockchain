// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

contract Whitelist is Ownable {
    mapping(address => bool) public whitelist;

    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "Not whitelisted");
        _;
    }

    function addToWhitelist(address participant) public onlyOwner {
        whitelist[participant] = true;
    }

    function removeFromWhitelist(address participant) public onlyOwner {
        whitelist[participant] = false;
    }

    function isWhitelisted(address participant) public view returns (bool) {
        return whitelist[participant];
    }
}
