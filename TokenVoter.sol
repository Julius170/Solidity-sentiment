
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
// initializes contract 
contract MarketSentiment {

    address public owner;
    string[] public tokenArray;

    //Initialized the owner off the contract to the contract's sender 
    constructor(){

        // owner of the contract
        owner = msg.sender;
    }

    // struct for details of each votes   
    struct token{
        bool exists;
        uint256 upVotes;
        uint256 downVotes;
        mapping (address => bool) Voters;
    }
    // mapps a string to a specific token
    mapping (string => token) private tokens;

    // updates the event of the token's details
    event tokenUpdated (
        uint256 upVotes,
        uint256 downVotes,
        address voter,
        string token
    );
    // modifier for verifying the owner of the contract  
    modifier verifyOwner() {
        // to check if this func is being called by owner
        require(msg.sender == owner, "Only owner is allowed to add tokens");
        _;
    }
    // adding a new token to the sentiment application 
    function addtoken(string memory _token) public verifyOwner() {
        // creating new token of type token, mapping the string _token to struct token
        token storage newtoken = tokens[_token];
        newtoken.exists = true;

        // adding the new token to the array
        tokensArray.push(_token);
    }
    // function for voting up or down for new token   
    function vote(string memory _token, bool _vote) public {
        // to check if voted token exists
        require(tokens[_token].exists == true, "token does not exist.");
        // to check if voter has not previously voted
        require(!tokens[_token].Voters[msg.sender], "You have already voted for this coin.");

        // create temporary token struct
        token storage t = tokens[_token];

        t.Voters[msg.sender] = true;

        if (_vote){
            t.upVotes++;
        }

        else{
            t.downVotes++;
        }

        // call tokenUpdated event

        emit tokenUpdated(t.upVotes, t.downVotes, msg.sender, _token);   
    }
        modifier tokenExists() {
      // to check if voted token exists
        require(tokens[_token].exists == true, "token does not exist.");
        }
    

    // function for getting the voted information of the token
    function getVotes(string memory _token) public view returns 
        (
            uint256 upVotes,
            uint256 downVotes
        ) {
        // create temporary token struct
        token storage t = tokens[_token];

        return (t.upVotes, t.downVotes);    
        }

}
