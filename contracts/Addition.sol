// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;
import "fhevm/lib/TFHE.sol";
import "fhevm/gateway/GatewayCaller.sol";

contract Addition is GatewayCaller {

    euint64 a;
    euint64 b;

    uint64 public _a;

    constructor(uint64 num){
        a = TFHE.asEuint64(num);
        TFHE.allow(a,address(this));
    }
    
    function setA(uint64 num) public  {
        a = TFHE.asEuint64(num);
        // TFHE.allow(a,address(this));
    }

    function addEN(uint64 num) public  {
        a = TFHE.add(a, num);
        TFHE.allow(a,address(this));
    }

    function addEE(uint64 num) public  {
        a = TFHE.add(TFHE.asEuint64(num), a);
        TFHE.allow(a,address(this));
    }

    function addEInput(einput encNum, bytes calldata numProof) public virtual {
        b = TFHE.asEuint64(encNum,numProof);
        a = TFHE.add(b,a);
        TFHE.allow(a,address(this));
    }

    function decrypt() public {
  	    uint256[] memory cts = new uint256[](1);
        cts[0] = Gateway.toUint256(a);
        Gateway.requestDecryption(cts, this.decryptValue.selector, 0, block.timestamp + 100, false);
    }

    function decryptValue(uint256  , uint64 decryptedInput) public returns (uint64) {
        _a = decryptedInput;
        return decryptedInput;
    }

}
