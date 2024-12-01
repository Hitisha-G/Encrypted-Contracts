// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;
import "fhevm/lib/TFHE.sol";
// import "fhevm/gateway/GatewayCaller.sol";

contract Operations  {

    euint64 a;
    
    function setA(uint64 num) public  {
        a = TFHE.asEuint64(num);
        TFHE.allow(a,address(this));
    }

}

