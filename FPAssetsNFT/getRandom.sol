pragma solidity >= 0.5.17;

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
    address public superManager = 0xe8754d9f9Ff5BEe78131c99692BC02E9D0Dd3ffD;
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

    function withdraw() external onlyManager{
        (msg.sender).transfer(address(this).balance);
    }

	function destroy() external onlyManager{ 
        selfdestruct(msg.sender); 
	}
}

library useDecimal{
    using uintTool for uint;

    function m278(uint n) internal pure returns(uint){
        return n.mul(278)/1000;
    }
}

contract GetRandomFPAContract is Manager, math{
	uint private startRate = 0;
	uint private MaxRate = 30;

    function setRate(uint amountstartRate) public onlyManager{
        startRate = amountstartRate;
    }

    function setMaxRate(uint amountstartRate) public onlyManager{
        MaxRate = amountstartRate;
    }
	
    function getTRandom(uint _mintIndex) public view returns(
        uint[] memory){

		uint raceStart = startRate;
		if(_mintIndex % 10000 < 500){
			raceStart = 4000;
		}
		
		uint getTypeRate = _random(block.number+_mintIndex, raceStart, 10000);
		uint typeRate = 0;
		if(getTypeRate >= 4000 && getTypeRate < 6900){
			typeRate = _random(block.number+_mintIndex, 1, MaxRate);
		}else if(getTypeRate >= 6900 && getTypeRate < 8400){
			typeRate = _random(block.number+_mintIndex, 2, MaxRate);
		}else if(getTypeRate >= 8400 && getTypeRate < 9200){
			typeRate = _random(block.number+_mintIndex, 4, MaxRate);
		}else if(getTypeRate >= 9200 && getTypeRate < 9700){
			typeRate = _random(block.number+_mintIndex, 6, MaxRate);
		}else if(getTypeRate >= 9700){
			typeRate = _random(block.number+_mintIndex, 8, MaxRate);
		}

		uint getRarityRate = _random(block.number+_mintIndex, raceStart, 10000);
		uint rarityRate = 0;
		if(getRarityRate >= 4000 && getRarityRate < 6900){
			rarityRate = _random(block.number+_mintIndex, 0, 2);
		}else if(getRarityRate >= 6900 && getRarityRate < 8400){
			rarityRate = _random(block.number+_mintIndex, 0, 3);
		}else if(getRarityRate >= 8400 && getRarityRate < 9200){
			rarityRate = _random(block.number+_mintIndex, 1, 4);
		}else if(getRarityRate >= 9200 && getRarityRate < 9700){
			rarityRate = _random(block.number+_mintIndex, 2, 5);
		}else if(getRarityRate >= 9700){
			rarityRate = _random(block.number+_mintIndex, 4, 5);
		}

		uint[] memory RandomRate = new uint[](2);
		RandomRate[0] = typeRate;
		RandomRate[1] = rarityRate;

        return RandomRate;
    }
	
    function _random(uint _block, uint bottom, uint top) private view returns(uint){
        bytes32 _hash = blockhash(_block);
        bytes memory seed = abi.encodePacked(rand(0, 1.15e77), _hash);
        return rand(seed, bottom, top);
    }
}