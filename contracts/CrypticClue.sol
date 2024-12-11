// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.24;
import "fhevm/lib/TFHE.sol";
import "fhevm/gateway/GatewayCaller.sol";

contract CrypticClue is GatewayCaller {

    eaddress public player1;
    address public _player1;
    address public owner;
    uint256 public roomCounter;

    address public add1;
    address public add2;

    bool public _result;

    uint64 public _guess;

    
    struct Room {
        eaddress player1;
        eaddress player2;
        bool isFull;
        euint32 secretNumber;
        bool isGameActive;
        ebool result;
        eaddress winner;
    }

    mapping(uint256 => Room) public rooms;
    mapping(uint256 => address[2]) public addressMapping;

    constructor(){
        owner = msg.sender;
        player1 = TFHE.asEaddress(0xa5e1defb98EFe38EBb2D958CEe052410247F4c80);
        // player1 = TFHE.asEaddress("0xa5e1defb98EFe38EBb2D958CEe052410247F4c80");
        TFHE.allow(player1, address(this));
    }
    
    function createRoom() public returns (uint256){
        roomCounter++;
        Room storage room = rooms[roomCounter];
  	    room.player1 = TFHE.asEaddress(msg.sender);
        TFHE.allow(room.player1, address(this));
        room.isFull= false;

        return roomCounter;
    }

    function joinRoom(uint256 roomId) public {
        Room storage room = rooms[roomId];
        room.player2 = TFHE.asEaddress(msg.sender);
        TFHE.allow(room.player2, address(this));
        room.isFull= true;
    }

    function setSecretNumber(uint256 roomId, uint32 number) public  {
        require(roomId > 0 && roomId <= roomCounter, "Invalid room ID");
        Room storage room = rooms[roomId];
        require(number >= 1 && number <= 20, "Number must be in range [1, 20]");
        room.isGameActive = true;
        // TFHE.allow(RoomKey[roomId], address(this));
        room.secretNumber = TFHE.asEuint32(number);
        // RoomKey[roomId] = TFHE.asEuint32(number);
        TFHE.allow(room.secretNumber, address(this));
        TFHE.allow(room.secretNumber, owner);
    }

    function submitKeyGuess(uint256 roomId, uint32 guessedKey) public  {
        require(roomId > 0 && roomId <= roomCounter, "Invalid room ID");
        Room storage room = rooms[roomId];
        require(room.isGameActive, "The game is not active");
        // require(TFHE.isSenderAllowed(TFHE.eq(room.player2, TFHE.asEaddress(msg.sender))), "not ");
        room.result = TFHE.eq(TFHE.asEuint32(guessedKey), room.secretNumber);
        TFHE.allow(room.result, address(this));
        // room.winner = TFHE.select(room.result, room.player2, room.player1);
        // emit GuessResult(roomId, TFHE.decrypt(isCorrect));
        room.isGameActive = false;
    }

    function inputAddress(einput add, bytes calldata addProof) public returns (bool) {
        player1 = TFHE.asEaddress(add,addProof);
        TFHE.allow(player1,address(this));
        // TFHE.allow(player1,owner);
        return true;
    }

    function decryptSecretNum(uint256 roomId) public  {
        Room memory room = rooms[roomId];
        euint32 num = room.secretNumber;
        uint256[] memory cts = new uint256[](1);
        cts[0] = Gateway.toUint256(num);
        Gateway.requestDecryption(cts, this.decryptSecretNumValue.selector, 0, block.timestamp + 100, false);
        // addParamsUint256(requestID, input1);
    }

    function decryptSecretNumValue(uint256 , uint32 decryptedInput) public returns (uint64) {
       _guess = decryptedInput;
        return decryptedInput;
    }

    function requestResult(uint256 roomId) public {
        Room memory room = rooms[roomId];
        uint256[] memory cts = new uint256[](1);
        cts[0] = Gateway.toUint256(room.result);
        Gateway.requestDecryption(cts, this.callbackResult.selector, 0, block.timestamp + 100, false);
    }

    function callbackResult(uint256, bool decryptedInput) public  returns (bool) {
        _result = decryptedInput;
        return decryptedInput;
    }


    function decryptPlayer(uint256 roomId) public virtual  {
        Room storage room = rooms[roomId];
        eaddress add = room.player1;
        eaddress addr2 = room.player2;
        uint256[] memory cts = new uint256[](2);
        cts[0] = Gateway.toUint256(add);
        cts[1] = Gateway.toUint256(addr2);

        uint256 requestID = Gateway.requestDecryption(cts, this.requestAddress.selector, 0, block.timestamp + 100, false);
        addParamsUint256(requestID, roomId);
    }

    function requestAddress(uint256 requestID, address decryptedInput1, address decryptedInput2) public returns(address){
        uint256[] memory params = getParamsUint256(requestID);
        unchecked{
            uint256 roomId = params[0];
            add1 = decryptedInput1;
            add2 = decryptedInput2;
            addressMapping[roomId][0]= 0xa5e1defb98EFe38EBb2D958CEe052410247F4c80;
            // addressMapping[roomId][1]= "0xa5e1defb98EFe38EBb2D958CEe052410247F4c80";
            // return addressMapping[roomId];
            return decryptedInput1;
        }
       
    }


    
}