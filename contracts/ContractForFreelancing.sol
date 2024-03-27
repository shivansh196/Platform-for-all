// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./PriceAggregator.sol";


///@dev All the errors for saving gas
error FreelancingBasicContract__NotEmployer();
error FreelancingBasicContract__NotEmployee();
error FreelancingBasicContract__AlreadyApplied();
error FreelancingBasicContract__EmployerCantEmployHimself();
error FreelancingBasicContract__NotApplied();
error FreelancingBasicContract__JobNotApproved();
error FreelancingBasicContract__PayNotAccepted();
error FreelancingBasicContract__NotEnoughEtherProvided();
error FreelancingBasicContract__PayOnlyOnceAMonth();
error FreelancingBasicContract__CantDismissInTheFirstMonth();

/** @title A contract for a decentralized freelancing platform;
 * @author Vagner Dragos Andrei 
 * @notice This is a personal project
 */
contract FreelancingContract {
    //Set the price aggregator
    //Type declaration
    using PriceAggregator for uint;
    
    ///Basic data structure that is used to make new jobs on the platfrom
    /// State variables
    struct Job {
        address employer;
        bool acceptPay;
        uint256 payCheckInUsd;
        string jobTitle;
        string jobDescription;
        address pending;
        address employee;
        uint256 timePassed;
    }

    /**
     * @dev A mapping of an adress to a boolean to see if an address is in the pending state
     */
    mapping(address => bool) private s_pending;
    /**
     * @dev A mapping of an unsigned integer to a Job struct to give each job an ID
     */
    mapping(uint => Job) public s_Jobs;
    /**
     * @dev A mapping of an address to an unsigned integer to show how many times an address has been paid;
     */

      mapping(address => uint) private s_timesHasBeenPaid;
    uint256 private s_numberOfListedJobs;

    
    // Modifiers
    modifier onlyEmployer(uint256 id) {
        Job memory job = s_Jobs[id];
        if(msg.sender != job.employer){
            revert FreelancingBasicContract__NotEmployer();
        }
        _;
    }

    modifier onlyEmployee(uint256 id) {
        Job memory job = s_Jobs[id];
        if(msg.sender != job.employee){
            revert FreelancingBasicContract__NotEmployee();
        }
        _;
    }

    /**
     * @dev This is the function to create new jobs
     * @dev Updates most of the struct
     * @param _jobTitle The title of the job that the employer needs
     * @param _jobDescription The description/requirements of the job
     * @return Return the number of the specific listed job so we can use it as an ID
     */
    function createJob(string memory _jobTitle, string memory _jobDescription) external returns(uint256) {
        Job storage job = s_Jobs[s_numberOfListedJobs];

        job.employer = msg.sender;
        job.jobTitle = _jobTitle;
        job.jobDescription = _jobDescription;
        s_numberOfListedJobs ++;

        return s_numberOfListedJobs - 1;
    }
    /**
     * @dev This function is used by employees to apply to a specific job
     * @param _id The id of the specific job listed
     */
    function applyJob(uint _id) external {
        Job storage job = s_Jobs[_id];
        if(s_pending[msg.sender]) {
            revert FreelancingBasicContract__AlreadyApplied();
        }   
        if(msg.sender == job.employer) {
            revert FreelancingBasicContract__EmployerCantEmployHimself();
        }    
        s_pending[msg.sender] = true;
        job.pending = msg.sender;
    }
    /**
     * @dev The function used by the creator of the job to accept a caditate
     * @param _candidate The address of the person who applied to a job
     * @param _id The id of the specific job
     */