// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;
import "fhevm/lib/TFHE.sol";
import "fhevm/gateway/GatewayCaller.sol";

contract EncryptedCounter is GatewayCaller {

    euint64 public counter;
    euint64 public operand;
    uint64 public _counter;
    address public owner;
    euint64 public value;
    euint64 public eNum;

    constructor() {
        counter = TFHE.asEuint64(10);
        _counter=10;
        owner = msg.sender;
    }

     function totalSupply() public view virtual returns (uint64) {
        return _counter;
    }

     function setCounter(uint64 num) public {
        _counter = num;
        counter =  TFHE.asEuint64(num);
        TFHE.allow(counter, address(this));
    }

    function increment(uint64 num) public {
        _counter = _counter + num;
        // // value = TFHE.add(TFHE.asEuint64(num), counter);
        // eNum = TFHE.asEuint64(num);
        // TFHE.allow(eNum, address(this));
        // counter =  TFHE.add(eNum, counter); 
        counter = TFHE.asEuint64(_counter);
        TFHE.allow(counter, address(this));
    }

    function decryptCounter() public  {
        uint256[] memory cts = new uint256[](1);
        cts[0] = Gateway.toUint256(counter);
        Gateway.requestDecryption(cts, this.decryptValue.selector, 0, block.timestamp + 100, false);
    }

    function decryptValue(uint256  , uint64 decryptedInput) public returns (uint64) {
        // uint256[] memory params = getParamsUint256(requestID);
        //  uint64 result = uint64(params[0]) + resultDecryption;
        _counter = decryptedInput;
        return decryptedInput;
    }
    
    function getCounter() public view returns (euint64) {
        return counter;
    }
}