// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ICheckIn } from "../interfaces/ICheckIn.sol";

library CheckInStorage {
    bytes32 constant STORAGE_POSITION = keccak256("goalquest.storage.checkin");

    struct Layout {
        // CheckIn ID counter
        uint32 checkInCounter;
        // CheckIn ID => CheckIn
        mapping(uint32 => ICheckIn.CheckIn) checkIns;
        // Task ID => User address => Timestamp => CheckIn ID
        mapping(uint32 => mapping(address => mapping(uint32 => uint32))) dailyCheckIns;
        // Task ID => User address => CheckIn count
        mapping(uint32 => mapping(address => uint32)) userCheckInCounts;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            l.slot := position
        }
    }
}