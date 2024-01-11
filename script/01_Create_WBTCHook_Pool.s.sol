// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PoolManager} from "v4-core/src/PoolManager.sol";
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";
import {CurrencyLibrary, Currency} from "v4-core/src/types/Currency.sol";
import {PoolId, PoolIdLibrary} from "v4-core/src/types/PoolId.sol";

contract CreatePoolScript is Script {
    using CurrencyLibrary for Currency;

    //addresses with contracts deployed
    address constant L_POOLMANAGER = address(0x99bbA657f2BbC93c02D617f8bA121cB8Fc104Acf); //pool manager deployed locally
    address constant WBTC_ADDRESS = address(0x95401dc811bb5740090279Ba06cfA8fcF6113778); //wBTC deployed locally 
    address constant MUSDC_ADDRESS = address(0xFD471836031dc5108809D173A067e8486B9047A3); //mUSDC deployed locally
    address constant HOOK_ADDRESS = address(0x80031B19B08d5aAe5c0f517f1cB0A281D2e5D51a); //address of the hook contract locally deployed

    IPoolManager manager = IPoolManager(L_POOLMANAGER);

    function run() external {
        // sort the tokens!
        address token0 = uint160(MUSDC_ADDRESS) < uint160(WBTC_ADDRESS) ? MUSDC_ADDRESS : WBTC_ADDRESS;
        address token1 = uint160(MUSDC_ADDRESS) < uint160(WBTC_ADDRESS) ? WBTC_ADDRESS : MUSDC_ADDRESS;
        uint24 swapFee = 4000;
        int24 tickSpacing = 10;

        // floor(sqrt(1) * 2^96)
        uint160 startingPrice = 79228162514264337593543950336;

        bytes memory hookData = abi.encode(block.timestamp);

        PoolKey memory pool = PoolKey({
            currency0: Currency.wrap(token0),
            currency1: Currency.wrap(token1),
            fee: swapFee,
            tickSpacing: tickSpacing,
            hooks: IHooks(HOOK_ADDRESS)
        });

        // Turn the Pool into an ID so you can use it for modifying positions, swapping, etc.
        PoolId id = PoolIdLibrary.toId(pool);
        bytes32 idBytes = PoolId.unwrap(id);

        console.log("Pool ID Below");
        console.logBytes32(bytes32(idBytes));

        vm.broadcast();
        manager.initialize(pool, startingPrice, hookData);
    }
}
