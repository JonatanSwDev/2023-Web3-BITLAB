// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface ITokenERC20 {
    function depositERC20(uint256 amountToDeposit) external;
    function withdrawERC20(uint256 withdrawAmount) external;

    event depositERC20Event(uint256 amount);
    event withdrawERC20Event(uint256 amount);
}

