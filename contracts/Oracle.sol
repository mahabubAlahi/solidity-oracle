pragma solidity ^0.8.9;


contract Oracle {
    struct Data {
        uint date;
        uint payload;
    }

    address public admin;
    mapping(address => bool) public reporters;
    mapping (bytes32=> Data) public data;

    constructor(address _admin) {
        admin = _admin;
    }

    function updateReporter(address reporter, bool isReporter) external {
        require(msg.sender == admin, 'Oracle: Only admin can update');

        reporters[reporter] = isReporter;
    }

    function updateDate(bytes32 key, uint payload) external {
        require(reporters[msg.sender] == true, 'only reporters');
        data[key] = Data(block.timestamp, payload);
    }
}