// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Whitelist.sol";

contract VoteAG is Whitelist {
    enum VoteChoice { POUR, CONTRE, NEUTRE }

    struct Resolution {
        uint id;
        string title;
        address president;
        address scrutateur;
        address secretaire;
        uint pour;
        uint contre;
        uint neutre;
        mapping(address => bool) hasVoted;
    }

    uint public resolutionCount;
    mapping(uint => Resolution) private resolutions;

    event ResolutionCreated(uint id, string title);
    event Voted(uint resolutionId, address voter, VoteChoice choice);

    function createResolution(
        string memory _title,
        address _president,
        address _scrutateur,
        address _secretaire
    ) public onlyOwner {
        resolutionCount++;
        Resolution storage r = resolutions[resolutionCount];
        r.id = resolutionCount;
        r.title = _title;
        r.president = _president;
        r.scrutateur = _scrutateur;
        r.secretaire = _secretaire;
        emit ResolutionCreated(resolutionCount, _title);
    }

    function vote(uint resolutionId, VoteChoice choice) public onlyWhitelisted {
        Resolution storage r = resolutions[resolutionId];
        require(!r.hasVoted[msg.sender], "Already voted");

        if (choice == VoteChoice.POUR) r.pour++;
        else if (choice == VoteChoice.CONTRE) r.contre++;
        else if (choice == VoteChoice.NEUTRE) r.neutre++;

        r.hasVoted[msg.sender] = true;
        emit Voted(resolutionId, msg.sender, choice);
    }

    function getResults(uint resolutionId) public view returns (
        string memory title,
        address president,
        uint pour,
        uint contre,
        uint neutre
    ) {
        Resolution storage r = resolutions[resolutionId];
        return (r.title, r.president, r.pour, r.contre, r.neutre);
    }
}
