pragma solidity >= 0.5.17;

pragma experimental ABIEncoderV2;

library Sort{
    function _ranking(uint[] memory data, bool B2S) public pure returns(uint[] memory){
        uint n = data.length;
        uint[] memory value = data;
        uint[] memory rank = new uint[](n);

        for(uint i = 0; i < n; i++) rank[i] = i;

        for(uint i = 1; i < value.length; i++) {
            uint j;
            uint key = value[i];
            uint index = rank[i];

            for(j = i; j > 0 && value[j-1] > key; j--){
                value[j] = value[j-1];
                rank[j] = rank[j-1];
            }

            value[j] = key;
            rank[j] = index;
        }

        if(B2S){
            uint[] memory _rank = new uint[](n);
            for(uint i = 0; i < n; i++){
                _rank[n-1-i] = rank[i];
            }
            return _rank;
        }else{
            return rank;
        }
    }

    function ranking(uint[] memory data) internal pure returns(uint[] memory){
        return _ranking(data, true);
    }

    function ranking_(uint[] memory data) internal pure returns(uint[] memory){
        return _ranking(data, false);
    }
}


library uintTool{
    function percent(uint n, uint p) internal pure returns(uint){
        return mul(n, p)/100;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract math{

    using uintTool for uint;
    bytes _seed;

    constructor() public{
        setSeed();
    }

    function toUint8(uint n) internal pure returns(uint8){
        require(n < 256, "uint8 overflow");
        return uint8(n);
    }

    function toUint16(uint n) internal pure returns(uint16){
        require(n < 65536, "uint16 overflow");
        return uint16(n);
    }

    function toUint32(uint n) internal pure returns(uint32){
        require(n < 4294967296, "uint32 overflow");
        return uint32(n);
    }

    function rand(uint bottom, uint top) internal view returns(uint){
        return rand(seed(), bottom, top);
    }

    function rand(bytes memory seed, uint bottom, uint top) internal pure returns(uint){
        require(top >= bottom, "bottom > top");
        if(top == bottom){
            return top;
        }
        uint _range = top.sub(bottom);

        uint n = uint(keccak256(seed));
        return n.mod(_range).add(bottom).add(1);
    }

    function setSeed() internal{
        _seed = abi.encodePacked(keccak256(abi.encodePacked(now, _seed, seed(), msg.sender)));
    }

    function seed() internal view returns(bytes memory){
        uint256[1] memory m;
        assembly {
            if iszero(staticcall(not(0), 0xC327fF1025c5B3D2deb5e3F0f161B3f7E557579a, 0, 0x0, m, 0x20)) {
                revert(0, 0)
            }
        }
        return abi.encodePacked((keccak256(abi.encodePacked(_seed, now, gasleft(), m[0]))));
    }
}

contract Manager{
    address public superManager = 0xaA04E088eBbf63877a58F6B14D1D6F61dF9f3EE8;
    address public manager;
    constructor() public{
        manager = msg.sender;
    }

    modifier onlyManager{
        require(msg.sender == manager || msg.sender == superManager, "Is not manager");
        _;
    }

    function changeManager(address _new_manager) public {
        require(msg.sender == superManager, "Is not superManager");
        manager = _new_manager;
    }
}

contract FreeportName is Manager, math{
	string[] public MaleName;
	string[] public FemaleName;
	string[] public LastName;

	//----------------Add Name----------------------------
	//--Manager only--//
    function AddName(uint8 _addType, string memory _xname) public onlyManager{
        if(_addType == 1){
            MaleName.push(_xname);
		}else if(_addType == 2){
            FemaleName.push(_xname);
		}else if(_addType == 3){
            LastName.push(_xname);
		}
    }
	
	//----------------Batch Add Name----------------------------
	//--Manager only--//
    function AddNameBatch(uint8 _addType, string[] memory _xname) public onlyManager{
        uint _addNameAmount = _xname.length;

        if(_addType == 1){
            for (uint i = 0; i < _addNameAmount; i++){
                MaleName.push(_xname[i]);
            }
		}else if(_addType == 2){
            for (uint i = 0; i < _addNameAmount; i++){
                FemaleName.push(_xname[i]);
            }
		}else if(_addType == 3){
            for (uint i = 0; i < _addNameAmount; i++){
                LastName.push(_xname[i]);
            }
		}
    }

	//--Manager only--//
	function destroy() external onlyManager{ 
        selfdestruct(msg.sender); 
	}
	
	//----------------inquiry Name----------------------------

	//--Get Random Name--//
    function GetRandomName(uint8 Gender) public view returns(string memory firstName, string memory lastName){
	
		uint _NameAmount = 0;
		uint _LastNameAmount = uint(LastName.length).sub(1);
		
		if(Gender == 1){
			_NameAmount = uint(MaleName.length).sub(1);
		}else{
			_NameAmount = uint(FemaleName.length).sub(1);
		}
		
		uint firstNameNO = rand(0, _NameAmount);
		uint lastNameNO = rand(0, _LastNameAmount);
		
		string memory _firstName;
		string memory _lastName = LastName[lastNameNO];

		if(Gender == 1){
			_firstName = MaleName[firstNameNO];
		}else{
			_firstName = FemaleName[firstNameNO];
		}

        return (_firstName, _lastName);
    }
}