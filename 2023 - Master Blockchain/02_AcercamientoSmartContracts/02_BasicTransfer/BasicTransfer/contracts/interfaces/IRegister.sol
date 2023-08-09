// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface IRegister {
    function registerUser(address user) external;
    event registerEvent(address user);
}