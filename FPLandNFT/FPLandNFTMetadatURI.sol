pragma solidity >= 0.5.17;

contract FPLandNFTURI {
    address public superManager = 0xaA04E088eBbf63877a58F6B14D1D6F61dF9f3EE8;
    address public manager;
	
	string public URIPreLink1 = '{"name": "Freeport Land NFT -';
	string public URIPreLink2 = '-","description": "Freeport Metaverse Land NFT.\r\n \r\nFreeport Metaverse is a block-chain game.\r\nWe are trying hard to build an evolable virtual world.\r\n \r\nWebSite:\r\nhttps://freeportmeta.com\r\n \r\nVideo:\r\nhttps://freeportmeta.com/youtube\r\n \r\nLinktree:\r\nhttps://linktr.ee/Freeportgame","external_link": "https://freeportmeta.com/FPLandNFT/ipfs/","image": "https://freeportmeta.com/FPLandNFT/ipfs/0/';
	string public URIPreLink3 = '.png","attributes": [{"trait_type": "Land Type","value": "';
	string public URIPreLink4 = '"},{"trait_type": "AreaNO","value": "';
	string public URIPreLink5 = '"},{"trait_type": "LandNO","value": "';
	string public URIPreLink6 = '"},{"trait_type": "CoordinateX","value": "';
	string public URIPreLink7 = '"},{"trait_type": "CoordinateY","value": "';
	string public URIPreLink8 = '"},{"trait_type": "ARA Daily Profit","value": "';
	string public URIPreLink9 = '"}]}';
	
    mapping (uint8 => string) public LandTypeName;
	
    constructor() public{
        manager = msg.sender;
		LandTypeName[0] = "";
		LandTypeName[1] = "Commercial Land";
		LandTypeName[2] = "Residential Land";
		LandTypeName[3] = "Agricultural Land";
		LandTypeName[4] = "Industrial Land";
		LandTypeName[5] = "Mining Land";
		LandTypeName[6] = "Sapphire Specific Sites";
		LandTypeName[7] = "Jadeite Specific Sites";
		LandTypeName[8] = "Amethyst Specific Sites";
    }

    modifier onlyManager{
        require(msg.sender == manager || msg.sender == superManager, "Not manager");
        _;
    }

    function changeManager(address _new_manager) public {
        require(msg.sender == superManager, "It's not superManager");
        manager = _new_manager;
    }

	//----------------Add URI----------------------------
	//--Manager only--//

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
	
	//--Get token URI uint--//
    function GettokenURI(
	uint8 _LandType,
	uint _AreaNO,
	uint _LandNO,
	uint _CoordinateX,
	uint _CoordinateY,
	uint _ARADailyProfit
	) public view returns(string memory){
	
        string memory _PreLink1 = GetPreLink1(_LandType);
        string memory _PreLink2 = GetPreLink2(_AreaNO, _LandNO);
        string memory _PreLink3 = GetPreLink3(_CoordinateX, _CoordinateY);
        string memory _PreLink4 = GetPreLink4(_ARADailyProfit);
        string memory _finalLink1 = strConcat(_PreLink1, _PreLink2);
        string memory _finalLink2 = strConcat(_PreLink3, _PreLink4);

        return strConcat(_finalLink1, _finalLink2);
    }

	//--Get PreLink1 string--//
    function GetPreLink1(uint8 _LandType) public view returns(string memory){
        string memory _LandTypeSTR = uint2str(uint(_LandType));
        string memory preURI = strConcat(URIPreLink1, LandTypeName[_LandType]);
        string memory preURI2 = strConcat(preURI, URIPreLink2);
        string memory preURI3 = strConcat(_LandTypeSTR, URIPreLink3);
        string memory preURI4 = strConcat(preURI3, LandTypeName[_LandType]);
		string memory finalURI = strConcat(preURI2, preURI4);
        return finalURI;
    }
	
	//--Get PreLink2 string--//
    function GetPreLink2(uint _AreaNO, uint _LandNO) public view returns(string memory){
        string memory _AreaNOSTR = uint2str(_AreaNO);
        string memory _LandNOSTR = uint2str(_LandNO);
        string memory preURI = strConcat(URIPreLink4, _AreaNOSTR);
        string memory preURI2 = strConcat(URIPreLink5, _LandNOSTR);
        string memory finalURI = strConcat(preURI, preURI2);  
        return finalURI;
    }
	
	//--Get PreLink3 string--//
    function GetPreLink3(uint _CoordinateX, uint _CoordinateY) public view returns(string memory){
        string memory _CoordinateXSTR = uint2str(_CoordinateX);
        string memory _CoordinateYSTR = uint2str(_CoordinateY);
        string memory preURI = strConcat(URIPreLink6, _CoordinateXSTR);
        string memory preURI2 = strConcat(URIPreLink7, _CoordinateYSTR);
        string memory finalURI = strConcat(preURI, preURI2);  
        return finalURI;
    }
	
	//--Get PreLink4 string--//
    function GetPreLink4(uint _ARADailyProfit) public view returns(string memory){
        string memory _ARADailyProfitSTR = uint2str(_ARADailyProfit);
        string memory preURI = strConcat(URIPreLink8, _ARADailyProfitSTR);
        string memory finalURI = strConcat(preURI, URIPreLink9);  
        return finalURI;
    }

	function strConcat(string memory _a, string memory _b) internal view returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint k = 0;

        for (uint i = 0; i < _ba.length; i++){
            bret[k++] = _ba[i];
        }
        for (uint i = 0; i < _bb.length; i++){
            bret[k++] = _bb[i];
        }
        return string(ret);
	} 
	
	//--Manager only--//
	function destroy() external onlyManager{ 
        selfdestruct(msg.sender); 
	}
}