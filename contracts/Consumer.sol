pragma solidity ^0.8.9;

import './IOracle.sol';

contract Consumer {
    IOracle public oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function foo() external{
        bytes32 key = keccak256(abi.encode('BTC/USD'));

        (bool result, uint timestamp, uint data) = oracle.getData(key);
        require(result == true, 'Consumer: Getting Price failed');
        require(timestamp >= block.timestamp - 2 minutes, 'Consumer: price too old');
    }
}