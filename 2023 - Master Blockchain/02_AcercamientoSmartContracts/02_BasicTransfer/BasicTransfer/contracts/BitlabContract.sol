// SPDX-License-Identifier: MIT
// Creado por Jonatan Gomez Garcia para la práctica de Solidity del MODULO 11

pragma solidity 0.8.17;

// IMPORT INTERFACES
import "./interfaces/ITokenMain.sol";
import "./interfaces/ITokenERC20.sol";
import "./interfaces/IRegister.sol";
// IMPORT LIBRERIES
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Contrato

contract BitlabContract is ReentrancyGuard, ITokenMain, ITokenERC20, IRegister{
    // Utilizar la libreria SafeERC20 sobre la interfaz IERC20
    using SafeERC20 for IERC20;

    // VARIABLES DE ESTADO
    address public owner;
    IERC20 token;

    mapping(address => bool) public whitelist;
    mapping(address => uint256) public depositosUser;
    mapping(address => uint256) public depositosERC20User;

    // Inicialiación de variables
    constructor(address tokenAddress){
        owner = msg.sender;
        token = IERC20(tokenAddress);
    }

    // Modificadores - require
    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyNotRegistered(address user){
        require(whitelist[user] != true, "User already registered");
        _;
    }

    modifier onlyRegisteredUser() {
        require(whitelist[msg.sender], "Only registered users can call this function.");
        _;
    }

    // Funcion register
    function registerUser(address user) onlyOwner onlyNotRegistered(user) external{
        whitelist[user] = true;
        emit registerEvent(user);
    }

    // Funciones ItokenMain
    function deposit() external payable nonReentrant onlyRegisteredUser {
        (bool success, ) = payable(address(this)).call{value: msg.value}("");
        require(success, "Error en el deosito");
        depositosUser[msg.sender] += msg.value;
        emit depositEvent(msg.value);
    }

    // A parte de usar nonReentrant actualizo la variable de estado antes de realizar el pago
    function withdraw(uint256 withdrawAmount) external nonReentrant onlyRegisteredUser {
        require(depositosUser[msg.sender] >= withdrawAmount, "Balance insuficiente para retirar");
        depositosUser[msg.sender] -= withdrawAmount;
        (bool success, ) = payable(msg.sender).call{value: withdrawAmount}("");
        require(success, "Error en la retirada!!");
        emit withdrawEvent(withdrawAmount);
    }

    // Funciones ItokenERC20
    function depositERC20(uint256 amountToDeposit) external nonReentrant onlyRegisteredUser {
        token.safeTransferFrom(msg.sender, address(this), amountToDeposit);
        depositosERC20User[msg.sender] += amountToDeposit;
        emit depositERC20Event(amountToDeposit);
    }

    // A parte de usar nonReentrant actualizo la variable de estado antes de realizar el pago
    function withdrawERC20(uint256 withdrawAmount) external nonReentrant onlyRegisteredUser {
      require(depositosERC20User[msg.sender] >= withdrawAmount, "Balance insuficiente para retirar");
       depositosERC20User[msg.sender] -= withdrawAmount;
       token.safeTransfer(msg.sender, withdrawAmount);
       emit withdrawEvent(withdrawAmount);
    }

    //Funcion obligatoria para recibir ETH
    receive() external payable {}
}


