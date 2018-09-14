pragma solidity 0.4.24;

/**
 * @title Fortube.io - Smart Contact for Fair Draw 
 * @author Fortube.io - https://github.com/fortube-official/rng
 * @dev This Smart Contact was developed by Fortube.io for a fair draw.
 */
contract fortubeRNG {

    address public founder;

    /** use the Event Hash to reference the games **/
    mapping(uint => EventGame) events;
  
    /** The structure will be used for future updates. **/
    struct EventWinner {
        uint ticket; 
        uint prizeRank;
        bytes32 prizeName;
        bytes32 userName;
        bytes32 evnetHash;
    }
    
    /** The structure will be used for future updates. **/
    struct EventGame {
        /** the Event id is used to reference the event **/
        uint id;
        /** the Event Owner is used to reference the event **/
        uint eventOwner;
        /** the hash of the event seed used for randomness generation **/
        bytes32 srvSeed;
        /** the timestamp of the raffle of the Event **/
        uint startAt;
        bytes32[] eventWinnerList; 
        mapping(bytes32 => EventWinner) eventWinnerStructs; 
    }
  
    constructor() public {
        founder = msg.sender;
    } 

    modifier onlyFounder {
        require(msg.sender == founder); 
        _;
    }
    
    event LogEventResult(uint256 randomNumber, bytes32 serverSeeds, uint256 prizeRank, string prizeName, string eventHash);
    
    /**
    * @dev Returns a random number
    * @param srvSeed - the server seed for generating random numbers
    * @param range - set the range of random numbers
    * @param prizeRank - prize ranking
    * @param prizeName - prize name
    * @param eventHash - event hash
    * @return random numbers
    */
    function generateWinner(bytes32 srvSeed, uint256 range, uint256 prizeRank, string prizeName, string eventHash) external onlyFounder returns (uint256) {
        uint256 seed = uint256(srvSeed);
        uint256 randomNumber = (uint256(keccak256(abi.encodePacked(block.blockhash(block.number-1), seed))) % range);
        emit LogEventResult(randomNumber, srvSeed, prizeRank, prizeName, eventHash);
        return randomNumber;
    }
    
}
