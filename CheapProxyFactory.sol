// SPDX-License-Identifier: MIT
pragma solidity ^0.7.1;

contract CheapProxyFactory {
    function spawnProxy(
        bytes32 salt,
        address implementation,
        bytes calldata data
    ) external payable returns (address newContract) {
        assembly {
            let freePointer:= mload(0x40)
            mstore(0x40, add(freePointer, 46))
            mstore(
                freePointer,
                0x6000368180378080368173000000000000000000000000000000000000000000
            )
            mstore(add(freePointer, 11), shl(0x60, implementation))
            mstore(
                add(freePointer, 31),
                0x5af43d82803e3d8282602c57fd5bf30000000000000000000000000000000000
            )
            newContract := create2(callvalue(), freePointer, 46, salt)
        }

        if (data.length > 0) {
            (bool success, bytes memory returnData) = newContract.call(data)
            require(success, string(returnData));
        }
    }
}
