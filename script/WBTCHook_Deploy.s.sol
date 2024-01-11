// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {PoolManager} from "v4-core/src/PoolManager.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {WBTCHook} from "../src/WBTCHook.sol";

contract WBTCHookScript is Script {
    address constant CREATE2_DEPLOYER = address(0x4e59b44847b379578588920cA78FbF26c0B4956C);
    address constant POOLMANAGER = address(0x99bbA657f2BbC93c02D617f8bA121cB8Fc104Acf);

    function setUp() public {}

    function run() public {
        // hook contracts must have specific flags encoded in the address
        uint160 flags = uint160(
            Hooks.BEFORE_INITIALIZE_FLAG
        );

        // Mine a salt that will produce a hook address with the correct flags
        (address hookAddress, bytes32 salt) =
            HookMiner.find(CREATE2_DEPLOYER, flags, type(WBTCHook).creationCode, abi.encode(address(POOLMANAGER)));

        
        // Deploy the hook using CREATE2
        vm.broadcast();
        WBTCHook wBTChook = new WBTCHook{salt: salt}(IPoolManager(address(POOLMANAGER)));
        require(address(wBTChook) == hookAddress, "WBTCHookScript: hook address mismatch");
        console.log(address(wBTChook));
    }
}
