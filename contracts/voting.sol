pragma solidity ^0.8.11;

contract Voting{
    address public administrator;
    WorkflowStatus public workflowStatus;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    uint private winningProposalId;

    struct Proposal {
    string description;   
    uint voteCount; 
    }

    struct Voter {
    bool isRegistered;
    bool hasVoted;  
    uint votedProposalId; 
    }

    enum WorkflowStatus {
        RegisteringVoters, 
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,

        VotingSessionEnded,
        VotesTallied
    }

    // TODO: constractor

    // this modifier checks the caller is the administrator
    modifier onlyAdministrator() {
        require(msg.sender==administrator, "The caller of this function must be an administrator");
        _;
    }

    // this modifier checks the the voter is registered
    modifier onlyRegisteredVoter() {
        require(voters[msg.sender].isRegistered, "Only registered voters can call this function");
        _;
    }

    // this modifier checks the proposal registration is active
    modifier onlyDuringVotersRegistration() {
        require(workflowStatus==WorkflowStatus.RegisteringVoters, "Only call this function when registering proposals");
        _;
    }

}