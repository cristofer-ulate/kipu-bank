# Contrato Inteligente - KipuBank - Estudiante Cristofer Ulate Bolaños

## Descripción de qué hace el contrato

Este contrato inteligente implementa una versión básica de un banco digital llamado **KipuBank**. Permite a los usuarios:

- Depositar ETH en su cuenta [FUNCIONA]
- Llevar un registro individual de balances por usuario el cual almacena en un mapping una lista de dirección de usuario y sus depósitos. 
  Permite que el usuario consulte su saldo actual [FUNCIONA]
- Retiro de tokens de la cuenta del usuario [NO FUNCIONA, PARECE QUE TENGO UNOS PROBLEMAS EN LOS MODIFICADORES Y LAS VALIDACIONES]


---

## Instrucciones de despliegue

1. Abrir Remix IDE (https://remix.ethereum.org/).
2. Cargar el archivo `KipuBank.sol` que se obtuvo del repositorio.
3. Ir a la pestaña **Solidity Compiler**, selecciona la versión 0.8.19. Hacer clic en **Compile**.
4. Ir a la pestaña **Deploy & Run Transactions**:
   - Asegurarse de tener seleccionada la billetera de Metamask así como el numero de cuenta adecuada.
   - En la sección **Deploy**, hay que ingresar los parámetros requeridos por el constructor, por ejemplo:
     ```
     _umbralRetiro = 100000000000000     // 0.0001 ether en wei
     _bankCap = 500000000000000000       // 0.5 ether en wei
     ```
   - Hacer clic en **Deploy**.
5. Esperar a que la transacción se confirme y se obtendrá la dirección del contrato desplegado.

---

## Cómo interactuar con el contrato

Una vez desplegado, la interfaz de Remix nos permite interactuar con el contrato.

### 1. `depositar(uint256 _monto)`
- Para este se debes:
  - Ingresar el monto como argumento en wei.
- Ejemplo:
  - `_monto = 100000000000000` (0.0001 ether)
- Si se busca el contrato en Etherscan seleccionado la red de Sepolia es posible ver el evento que se genera con el depósito.

### 2. Retirar
Por algunos problemas con los modificadores esta funcion NO FUNCIONA de momento.

### 3. Ver tu balance
El contrato incluye la funcion `getBalance()` con la cual se puede ver el saldo actual del usuario.

### 4. Ver Cantidad de Depósitos y Cantidad de Retiros
Tambien es posible ver el contador de depósitos y retiros.
