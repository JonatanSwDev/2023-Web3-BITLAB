// SPDX-License-Identifier: MIT
// Creado por Jonatan Gomez Garcia para la práctica de Solidity del MODULO 11

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestToken is ERC20, ERC20Burnable, Pausable, Ownable {
    constructor() ERC20("TestToken", "TTK") {}

    // Funcion que pausa el contrato "Circuit breaker" en caso de emergencia
    function pause() external onlyOwner {
        _pause();
    }
 
    // Funcion que quita la pausa del contrato
    function unpause() external onlyOwner {
        _unpause();
    }

    // Funcion para mintear Tokens a un destinatario. Solo puede ser llamada por el owner
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Funcion Hook. Esta función entra en funcionamiento ántes de transferir el token
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal whenNotPaused override {
            super._beforeTokenTransfer(from, to, amount);
        }
}