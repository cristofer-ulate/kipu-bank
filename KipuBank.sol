// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title KipuBank
 * @dev Contrato de Examen Final Modulo 2
 * El contrato funciona como un banco permitiendo enviar y recibir tokens
 */
contract KipuBank {
    
    // ============== VARIABLES DE ESTADO ==============

    uint256 public immutable umbralRetiro; // Variable tipo Immutable que lleva el umbral fijo por transacción de tipo retiros
    uint256 public immutable bankCap; // Variable tipo Immutable que lleva el límite máximo de depósito global
    uint256 private cantDepositos; // Variable tipo storage para llevar el contador de depositos
    uint256 private cantRetiros; // Variable tipo storage para llevar el contador de retiros
    mapping(address => uint256) private balances; // Variable tipo storage para llevar el balance de las cuentas. Usa el tipo Mapping
    
    // ============== EVENTOS ==============
    
    event EtherDepositado(address indexed usuario, uint256 monto);
    event EtherRetirado(address indexed usuario, uint256 monto);
    
    // ============== ERRORES PERSONALIZADOS ==============

    error LimitesGlobalesDebenSerMayorQue0(uint256 _umbralRetiro, uint256 _bankCap);
    error DepositoExcedeLimiteGlobal(uint256 monto, uint256 limiteBankCap);
    error RetiroExcedeUmbral(uint256 monto, uint256 umbralRetiro);
    error FondosInsuficientesParaRetiro(uint256 saldoDisponible, uint256 montoSolicitado);
    error MontoInvalido();
    error TransferenciaFallida();

    // ============== CONSTRUCTOR ==============
    
    constructor(uint256 _umbralRetiro, uint256 _bankCap) {
        if (_umbralRetiro <= 0 || _bankCap <=  0) { revert LimitesGlobalesDebenSerMayorQue0(_umbralRetiro, _bankCap); }
        umbralRetiro = _umbralRetiro; // Umbral para los retiros
        bankCap = _bankCap; // Limite global de los depositos
        cantDepositos = 0; // Inicializa el contador de depositos
        cantRetiros = 0; // Inicializa el contador de retiros
    }

    // ============== MODIFICADORES ==============
    
    /**
     * @dev Valida que los montos de las transacciones sean mayores a cero
     */
     /*
    modifier montoValido(uint256 _monto) {
  
        if (_monto <= 0) revert MontoInvalido();
        _;
    }
    */

    /**
     * @dev Valida que el monto de deposito este bajo el limite global de depositos BankCap
     */
    /*
    modifier depositoMenorQueBankCap(uint256 _monto) {
        if (_monto > bankCap) {
            revert DepositoExcedeLimiteGlobal(_monto, bankCap);
        }
        _;
    }
    */

    /**
     * @dev Valida que el monto de retiro este bajo el umbral de retiros definido
     */
    /*
    modifier retiroMenorQueUmbralRetiro(uint256 _monto) {
        if (_monto > umbralRetiro) {
            revert RetiroExcedeUmbral(_monto, umbralRetiro);
        }
        _;
    }
    */

    // ============== FUNCIONES PARA DEPOSITAR (RECIBIR) ETHER ==============
    /**
     * @dev Realiza el deposito de un monto. Uso de funcion EXTERNAL y PAYABLE
     */
    function depositar(uint256 _monto) external payable { //depositoMenorQueBankCap(_monto) {  
        balances[msg.sender] += _monto;
        cantDepositos++;

        emit EtherDepositado(msg.sender, _monto);
    }

    /**
     * @dev Transfiere el monto retirado a la cuenta destinataria. Uso de una funcion PRIVATE 
     */
    function transferirETH(address _destinatario, uint256 _monto) private {  
        (bool resultado,) = _destinatario.call{value: _monto}("");
        if (!resultado) { revert TransferenciaFallida(); }
        
        emit EtherRetirado(msg.sender, _monto);
    }
    
    // ============== FUNCIONES PARA RETIRAR (ENVIAR) ETHER ==============
    /**
     * @dev Inicia el retiro, valida los montos y llama a la funcion de transferir. Uso de una funcion EXTERNAL
     */
    function retirar(uint256 _monto) external { // retiroMenorQueUmbralRetiro(_monto) {
        // Patron checks - effects - interactions:
        
        // 1. CHECKS: Leo el saldo del usuario
        uint256 saldoDisponible = balances[msg.sender];
        
        // 2. CHECKS: Valido que tenga dinero
        if (saldoDisponible <= 0 || saldoDisponible < _monto) {
            revert FondosInsuficientesParaRetiro(saldoDisponible, _monto);
        }

        // 3. EFFECTS: Actualizo el balance de la cuenta antes de hacer la transferencia de ETH
        balances[msg.sender] -= _monto;
        cantRetiros++;

        // 4. INTERACTIONS: Finalmente envio los tokens
        transferirETH(msg.sender, _monto);
    }

    // ============== FUNCIONES AUXILIARES ==============
    
    /**
     * @dev Retorna el balance del usuario. Uso de una funcion EXTERNAL y con VIEW
     */
    function getBalance() external view returns (uint256) { 
        return balances[msg.sender];
    }

    /**
     * @dev Retorna la cantida de depositos
     */
    function getCantDepositos() external view returns (uint256) { 
        return cantDepositos;
    }

    /**
     * @dev Retorna la cantida de retiros
     */
    function getCantRetiros() external view returns (uint256) { 
        return cantRetiros;
    }
}
