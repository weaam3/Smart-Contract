//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26; 

contract Crowdfunding{
    address public owner;
    address payable public receiver;    // accept payable addresses
    uint public totalContributions;     // unit = unit256
    uint public goalCertainAmount;      
    bool public isFunded;          // Flag to track if the funds have been released          

    mapping(address => uint) public contributions; // stores the number of tokens each address has

    // Event that logs each contribution
    event ContributionReceived(address user, uint amount);
    // Event that logs the release of funds to the recipient
    event FundsReleased(address receiver, uint amount);


    // Initialize the contract
    constructor(address payable _receiver, uint EtherGoalCertainAmount) {
        owner = msg.sender; // the address of the genetrator of the contract becomes the owner
        receiver = _receiver;   
        goalCertainAmount = EtherGoalCertainAmount * 1 ether;  // convert the goal to Wei unit
        isFunded = false;  // initially, funds are not released
    }

    modifier onlyReceiver() {
        require(msg.sender == receiver, "Not the beneficiary");
        _; //Rest of the function body execution
    }    


    function theProcess() public payable {

        require(!isFunded, "Funding is already completed");

        // Get the contribution from the sender (users)
        uint contribution = msg.value;
        contributions[msg.sender] += contribution;
        
        totalContributions += contribution;

        // Launch an event to log the users' contributions.
        emit ContributionReceived(msg.sender, msg.value);

        // Release the funds if the total contributions reach a certain amount
        if (totalContributions >= goalCertainAmount) {
            releaseFunds();
        }

    }

    function releaseFunds() public onlyReceiver{

        require(totalContributions >= goalCertainAmount, "The goal has not been reached");
        require(!isFunded, "The Funds have already been released");

        // Set the flag to true indicating funds have been released
        isFunded = true;

        receiver.transfer(totalContributions);  // Transfer funds to the receiver.
        emit FundsReleased(receiver, totalContributions);

    }
    
}