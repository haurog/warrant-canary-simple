// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/// @title Warrant Canary
/// @author haurog
/// @notice A warrant canary contract implementation

contract WarrantCanary {

    uint public IDcount;
    struct warrantCanary {
        uint ID;
        uint expirationTime;
        uint lastUpdatedInBlock;  // tracks in which block the expirationTime has changed.
        string purpose;
        address payable warrantCanaryOwner;
    }

    mapping(uint => warrantCanary) public  warrantCanaries;  // All warrant canaries accessed by IDs.
    mapping(address => uint[]) public IDsOwned;  // Store all warrant canaries that an address owns.


    modifier onlyCanaryOwner(uint warrantCanaryID) {
        require(msg.sender == warrantCanaries[warrantCanaryID].warrantCanaryOwner,
                "You are not the owner of this warrant canary.");
        _;
    }

    /// @notice Creates a new Warrant Canary.
    /// @param expirationTime_: The time (unix epoch in seconds) when the warrant canary expires.
    /// @param purpose_: A string describing the purpose of the warrant canary.
    function createWarrantCanary(
        uint expirationTime_,
        string memory purpose_
    )
        public
    {
        warrantCanaries[IDcount] = warrantCanary(
        {
            ID : IDcount,
            expirationTime: expirationTime_,
            lastUpdatedInBlock: block.number,
            purpose: purpose_,
            warrantCanaryOwner: payable(msg.sender)
        });

        IDsOwned[msg.sender].push(IDcount);
        IDcount++;

    }

    /// @notice Update the expiration time for an owned warrant canary contract.
    /// @param warrantCanaryID_: ID (uint) of the warrant canary whose expiration time should be changed.
    /// @param newExpirationTime_: The time (unix epoch in seconds) when the warrant canary expires.
    function updateExpiration(uint warrantCanaryID_, uint newExpirationTime_) public {
        uint oldExpirationTime = warrantCanaries[warrantCanaryID_].expirationTime;
        warrantCanaries[warrantCanaryID_].expirationTime= newExpirationTime_;
        updateLastUpdatedInBlock(warrantCanaryID_);
    }

    /// @notice Delete a given warrant canary.
    /// @param warrantCanaryID_: ID (uint) of the warrant canary which should be deleted.
    /// @dev The function also deletes the warrant canary ID from all IDsTrusted and IDsOwned.
    function deleteWarrantCanary(uint warrantCanaryID_) public onlyCanaryOwner(warrantCanaryID_) {
        // deletes the warrant canary from the mapping

        address wcOwner = warrantCanaries[warrantCanaryID_].warrantCanaryOwner;

        IDsOwned[wcOwner] = removeByValue(IDsOwned[wcOwner], warrantCanaryID_);

        delete warrantCanaries[warrantCanaryID_];
    }

    /// @notice Updates the variable "lastUpdatedInBlock" in the warrant canary.
    /// @param warrantCanaryID_: ID (uint) of the warrant canary which should be deleted.
    function updateLastUpdatedInBlock(uint warrantCanaryID_) internal {
        warrantCanaries[warrantCanaryID_].lastUpdatedInBlock = block.number;
    }

    /// @notice A getter function get an array of all owned warrant Canary IDs back.
    /// @param wcOwner: Address of which all the owned IDs are returned.
    /// @return an array (can be empty) with all owned warrant canaries.
    function getIDsOwned(address wcOwner)
        public
        view
        returns(uint[] memory)
    {
        return IDsOwned[wcOwner];
    }

    /// @notice A helper function to remove an entry from an array by value.
    /// @param array_: Array from which an entry should be removed.
    /// @param valueToDelete_: Value of the entry to be deleted.
    /// @dev Keeps the order of the non removed elements (more expensive and not really necessary in this project).
    function removeByValue(uint[] storage array_, uint valueToDelete_)
        private
        returns(uint[] storage)
    {
        uint index = 0;
        // find index of the value (is unique)
        for(; index <= array_.length && array_[index] != valueToDelete_ ; index++){}

        // shift all elements after index one element upwards
        for (; index < array_.length - 1; index++){
            array_[index] = array_[index + 1];
        }
        // delete last element
        array_.pop();

        return array_;
    }
}