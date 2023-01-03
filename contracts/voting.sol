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

    // this modifier checks the voter registration is active
    modifier onlyDuringVotersRegistration() {
        require(workflowStatus==WorkflowStatus.RegisteringVoters, "Only call this function when registering voters");
        _;
    }

    // this modifier checks the proposal registration is active
    modifier onlyDuringProposalRegistration() {
        require(workflowStatus==WorkflowStatus.ProposalsRegistrationStarted, "Only call this function when registering proposals");
        _;
    }

    // this modifier checks the proposal registration period has ended 
    modifier onlyAfterProposalRegistration() {
        require(workflowStatus==WorkflowStatus.ProposalsRegistrationEnded, "only call this function after proposal registration ended");
        _;
    }

    modifier onlyDuringVotingSession() {
        require(workflowStatus==WorkflowStatus.VotingSessionStarted, "only call this function after voting session started");
        _;
    }

    modifier onlyAfterVotingSession() {
        require(workflowStatus==WorkflowStatus.VotingSessionEnded, "only call this function after voting session ended");
        _;
    }

    modifier onlyAfterVotesTallied() {
        require(workflowStatus==WorkflowStatus.VotesTallied, "only call this function after votes were tallied");
        _;
    }

    event VoterRegisteredEvent (address voterAddress); 
    event ProposalsRegistrationStartedEvent ();
    event ProposalsRegistrationEndedEvent ();
    event ProposalRegisteredEvent(uint proposalId);
    event VotingSessionStartedEvent ();
    event VotingSessionEndedEvent ();
    event VotedEvent (address voter, uint proposalId);
    event VotesTalliedEvent ();

    event WorkflowStatusChangeEvent (
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );



}