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