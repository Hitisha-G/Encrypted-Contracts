// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.24;
import "fhevm/lib/TFHE.sol";
import "fhevm/gateway/GatewayCaller.sol";

contract CrypticClue is GatewayCaller {

    eaddress player1;
    address public _player1;

    struct AddressStruct{
        eaddress a1;
        eaddress a2;
    }

    constructor(){
        player1 = TFHE.asEaddress(0xa5e1defb98EFe38EBb2D958CEe052410247F4c80);
        // player1 = TFHE.asEaddress("0xa5e1defb98EFe38EBb2D958CEe052410247F4c80");
        TFHE.allow(player1, address(this));
    }

    // function setAddr(address _a1,address _a2) public {
    //     AddressStruct storage addr = new AddressStruct;

    // }


    function inputAddress(einput add, bytes calldata addProof) public returns (bool) {
        player1 = TFHE.asEaddress(add,addProof);
        TFHE.allow(player1,address(this));
        return true;
    }

    function decryptPlayer() public {
        uint256[] memory cts = new uint256[](1);
        cts[0] = Gateway.toUint256(player1);
        Gateway.requestDecryption(cts, this.callbackAddress.selector, 0, block.timestamp + 100, false);
    }

    function callbackAddress(uint256, address decryptedInput) public returns(address) {
        _player1 = decryptedInput;
        return decryptedInput;
    }
    

}