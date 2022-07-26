//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// initializes contract
contract MarketSentiment {
    address public owner;

    //Initialized the owner of the contract to the contract's deployer
    constructor() {
        // owner of the contract
        owner = msg.sender;
    }

    // struct for details of each votes
    struct token {
        bool exists;
        bool ended;
        uint256 upVotes;
        uint256 downVotes;
        mapping(address => bool) Voters;
    }
    // maps a string to a specific token
    mapping(string => token) private tokens;

    /// @dev updates the event of the token's details
    event tokenUpdated(
        uint256 upVotes,
        uint256 downVotes,
        address voter,
        string token
    );

    /// @dev modifier for verifying the owner of the contract
    modifier verifyOwner() {
        // to check if this func is being called by owner
        require(msg.sender == owner, "Only owner is allowed to add tokens");
        _;
    }
    /// @dev modifier for verifying if the token exist
    modifier tokenExists(string calldata _token) {
        // to check if voted token exists
        require(tokens[_token].exists == true, "token does not exist.");
        _;
    }

    /// @dev adding a new token to the sentiment application
    function addtoken(string calldata _token) external verifyOwner {
        require(!tokens[_token].exists, "token already exist");
        // creating new token of type token, mapping the string _token to struct token
        tokens[_token].exists = true;
    }

    /// @dev function for voting up or down for new token
    function vote(string calldata _token, bool _vote)
        external
        tokenExists(_token)
    {
        require(!tokens[_token].ended, "voting for token is over");
        // to check if voter has not previously voted
        require(
            !tokens[_token].Voters[msg.sender],
            "You have already voted for this coin."
        );

        // create temporary token struct
        token storage t = tokens[_token];

        t.Voters[msg.sender] = true;

        if (_vote) {
            t.upVotes++;
        } else {
            t.downVotes++;
        }

        // emits tokenUpdated event
        emit tokenUpdated(t.upVotes, t.downVotes, msg.sender, _token);
    }

    /// @dev function for ending the voting period on a token
    function endVote(string calldata _token) external tokenExists(_token) verifyOwner() {
        require(!tokens[_token].ended, "voting is already over");
        tokens[_token].ended = true;
    }

    /// @dev function for getting the voted information of the token
    function getVotes(string calldata _token)
        public
        view
        tokenExists(_token)
        returns (uint256 upVotes, uint256 downVotes)
    {
        // create temporary token struct
        token storage t = tokens[_token];

        return (t.upVotes, t.downVotes);
    }
}
