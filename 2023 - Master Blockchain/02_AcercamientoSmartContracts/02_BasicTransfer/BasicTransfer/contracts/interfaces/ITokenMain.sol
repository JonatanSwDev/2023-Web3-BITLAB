// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface ITokenMain {
    function deposit() external payable ;
    function withdraw(uint256 withdrawAmount) external;
    
    event depositEvent(uint256 amount);
    event withdrawEvent(uint256 amount);
}


