pragma solidity ^0.8.9;


interface IOracle{

    function getData(bytes32 key) 
        external 
        view 
        returns(bool result, uint date, uint payload);

    function updateReporter(address reporter, bool isReporter) 
        external;

    function updateData(bytes32 key, uint payload) 
        external;
}