pragma solidity ^0.8.0;

contract Store {
    
    uint256 totalMessages;
    event NewMessage(address indexed from, uint256 timestamp, string message);
    uint256 private seed;
    
    constructor () payable {
    }
    
    struct Message {
        address messager; // The address of the user who messaged.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user messaged.
    }
    
    Message[] messages;
    
    mapping(address => uint256) public lastMessagedAt;
    
    function sendMessage(string memory _message) public {
        require(
            lastMessagedAt[msg.sender] + 10 seconds < block.timestamp,
            "Wait 10 seconds"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastMessagedAt[msg.sender] = block.timestamp;
        
        totalMessages += 1;
        
        // store the message data in the array
        messages.push(Message(msg.sender, _message, block.timestamp));
        emit NewMessage(msg.sender, block.timestamp, _message);
        
        //send some eth to user
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;

        //Set the generated, random number as the seed for the next wave
        seed = randomNumber;

        if (randomNumber < 10) {
        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
        
        }

    }

    function getTotalMessages() public view returns (uint256) {
        return totalMessages;
    }
    
    function getAllMessages() public view returns (Message[] memory) {
        return messages;
    }
}
