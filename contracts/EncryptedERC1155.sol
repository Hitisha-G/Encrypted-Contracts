// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "fhevm/lib/TFHE.sol";
import "fhevm/gateway/GatewayCaller.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

contract EncryptedERC1155 is GatewayCaller {
    //tokenid => (address=> encrypted balance)
    mapping(uint256 => mapping(address => euint64)) public _balances;
    //tokenid => (address => decrypted balance)
     mapping(uint256 => mapping(address => uint64)) public  _decryptedBalances;
    // owner => (operator => yes/no)
    mapping(address => mapping(address => bool)) internal _operatorApprovals;
    // token id => token uri
    mapping(uint256 => string) internal _tokenUris;
    // token id => supply
    mapping(uint256 => uint256) public totalSupply;

    uint256 public nextTokenIdToMint ;
    string public name;
    string public symbol;
    address public owner;
    uint64 public bal;

    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, euint64 value);

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        euint64[] values
    );

    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event Mint(address indexed to, uint64 amount);

    constructor(string memory _name, string memory _symbol) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        nextTokenIdToMint = 1;
    }

    function balanceOf(address _owner, uint256 _tokenId) public view returns(euint64) {
        require(_owner != address(0), "Add0");
        return _balances[_tokenId][_owner];
    }

    //mint 
    function mint(uint256 _tokenId, uint64 _amount) public {
        require(owner == msg.sender, "not authorized");

        uint256 tokenIdToMint;

        // if (_tokenId == type(uint256).max) {
        //     tokenIdToMint = nextTokenIdToMint;
        //     nextTokenIdToMint += 1;
        //     _tokenUris[tokenIdToMint] = _uri;
        // } else {
            // require(_tokenId < nextTokenIdToMint, "invalid id");
            tokenIdToMint = _tokenId;
        // }

        _balances[tokenIdToMint][owner] = TFHE.add(_balances[tokenIdToMint][owner], _amount); 
        totalSupply[tokenIdToMint] += _amount;
        TFHE.allow( _balances[tokenIdToMint][owner], address(this));
        TFHE.allow( _balances[tokenIdToMint][owner], owner);
        
        emit Mint(owner, _amount);
    }

    function transfer(address to,uint256 _id, einput encryptedAmount, bytes calldata inputProof) public virtual returns (bool) {
        safeTransferFrom(msg.sender, to,_id, TFHE.asEuint64(encryptedAmount, inputProof));
        return true;
    }

    //transfer
    function safeTransferFrom(address _from, address _to, uint256 _id, euint64 _amount) public {
        require(_from == msg.sender || isApprovedForAll(_from, msg.sender), "not authorized");
        // create an array
        uint256[] memory ids = new uint256[](1);
        euint64[] memory amounts = new euint64[](1);
        ids[0] = _id;
        amounts[0] = _amount;
        // transfer
        _transfer(_from, _to, ids, amounts);
        emit TransferSingle(msg.sender, _from, _to, _id, _amount);
        // safe transfer checks
        // _doSafeTransferAcceptanceCheck(msg.sender, _from, _to, _id, _amount, _data);
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, euint64[] memory _amounts) public {
        require(_from == msg.sender || isApprovedForAll(_from, msg.sender), "not authorized");
        require(_ids.length == _amounts.length, "length mismatch");

        _transfer(_from, _to, _ids, _amounts);
        emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);

        // _doSafeBatchTransferAcceptanceCheck(msg.sender, _from, _to, _ids, _amounts, _data);
    }


    function setApprovalForAll(address _operator, bool _approved) public {
        _operatorApprovals[msg.sender][_operator] = _approved;
    }

    function isApprovedForAll(address _account, address _operator) public view returns(bool) {
        return _operatorApprovals[_account][_operator];
    }

    function _transfer(address _from, address _to, uint256[] memory _ids, euint64[] memory _amounts) internal {
        require(_to != address(0), "transfer to address 0");

        for (uint256 i = 0; i < _ids.length; i++) {
            uint256 id = _ids[i];
            euint64 amount = _amounts[i];

            // euint64 fromBalance = _balances[id][_from];
            // require(fromBalance >= amount, "insufficient balance for transfer");
            _balances[id][_from] = TFHE.add( _balances[id][_from], amount); 
            TFHE.allow( _balances[id][_from], address(this));
            _balances[id][_to] =  TFHE.add( _balances[id][_to], amount);
            TFHE.allow( _balances[id][_to], address(this));
        }
    }

    function decryptBalance(address _add, uint256 _id) public {
        euint64 a = _balances[_id][_add];
        uint256[] memory cts = new uint256[](1);
        cts[0] = Gateway.toUint256(a);
        uint256 requestID = Gateway.requestDecryption(cts, this.decryptValue.selector, 0, block.timestamp + 100, false);
        addParamsUint256(requestID, _id);
        addParamsAddress(requestID, _add);
    }

    function decryptValue(uint256 requestID, uint64 decryptedInput)public returns(uint64){
        uint256[] memory params = getParamsUint256(requestID);
        address[] memory add = getParamsAddress(requestID);
        // bytes[] memory paramss = getParams
        unchecked {
            // uint32 result = uint32(params[0]) + uint32(params[1]) + decryptedInput;
            uint256 id = params[0];
            address addr = add[0];
           _decryptedBalances[id][addr] = decryptedInput;
            bal = decryptedInput;
        return decryptedInput;
        }
        // _decryptedBalances[_id][_add] = decryptedInput;
        // bal = decryptedInput;
        // return decryptedInput;
    }

    // function _doSafeTransferAcceptanceCheck(
    //     address operator,
    //     address from,
    //     address to,
    //     uint256 id,
    //     uint256 amount,
    //     bytes memory data
    // ) private {
    //     if (to.code.length > 0) {
    //         try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
    //             if (response != IERC1155Receiver.onERC1155Received.selector) {
    //                 revert("ERC1155: ERC1155Receiver rejected tokens");
    //             }
    //         } catch Error(string memory reason) {
    //             revert(reason);
    //         } catch {
    //             revert("ERC1155: transfer to non-ERC1155Receiver implementer");
    //         }
    //     }
    // }

    // function _doSafeBatchTransferAcceptanceCheck(
    //     address operator,
    //     address from,
    //     address to,
    //     uint256[] memory ids,
    //     uint256[] memory amounts,
    //     bytes memory data
    // ) private {
    //     if (to.code.length > 0) {
    //         try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
    //             bytes4 response
    //         ) {
    //             if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
    //                 revert("ERC1155: ERC1155Receiver rejected tokens");
    //             }
    //         } catch Error(string memory reason) {
    //             revert(reason);
    //         } catch {
    //             revert("ERC1155: transfer to non-ERC1155Receiver implementer");
    //         }
    //     }
    // }

}




