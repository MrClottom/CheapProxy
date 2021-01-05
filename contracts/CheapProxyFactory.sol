// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CheapProxyFactory {
    function spawnProxy(
        bytes32 salt,
        address implementation,
        bytes calldata data
    ) external payable returns (address newContract) {
        assembly {
            let freePointer:= mload(0x80)
            mstore(0x80, add(freePointer, 67))
            mstore(add(freePointer, 37), 0x5af43d82803e3d8282602c57fd5bf3)
            mstore(add(freePointer, 20), implementation)
            mstore(freePointer, 0x6000368180378080368173)
            newContract := create2(callvalue(), add(freePointer, 21), 46, salt)
        }

        if (data.length > 0) {
            (bool success, bytes memory returnData) = newContract.call(data);
            require(success, string(returnData));
        }
    }
}
