pragma solidity >= 0.5.17;

contract FPSSBtokenID {
    address public superManager = 0xaA04E088eBbf63877a58F6B14D1D6F61dF9f3EE8;
    address public manager;

    constructor() public{
        manager = msg.sender;
    }

    modifier onlyManager{
        require(msg.sender == manager || msg.sender == superManager, "Not manager");
        _;
    }

    function changeManager(address _new_manager) public {
        require(msg.sender == superManager, "It's not superManager");
        manager = _new_manager;
    }

    function GetSSBtokenID(uint _tokenID) public view returns(bool){
        bool IsSSBtokenID = false;
		if(_tokenID >= 10005 && _tokenID <= 10838){
            IsSSBtokenID = true;
		}
		if(_tokenID >= 10927 && _tokenID <= 11994){
            IsSSBtokenID = true;
		}
		if(_tokenID >= 12074 && _tokenID <= 12172){
            IsSSBtokenID = true;
		}
        return IsSSBtokenID;
    }

/*
    function GetSSBtokenID(uint _tokenID) public view returns(bool){
        bool IsSSBtokenID = false;
		if(_tokenID >= 34 && _tokenID <= 39){
            IsSSBtokenID = true;
		}
		if(_tokenID >= 40 && _tokenID <= 49){
            IsSSBtokenID = true;
		}
		if(_tokenID >= 50 && _tokenID <= 63){
            IsSSBtokenID = true;
		}
        return IsSSBtokenID;
    }
	*/
}