
// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol

pragma solidity >=0.6.0 <0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

pragma solidity >=0.6.0 <0.8.0;

library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

pragma solidity >=0.6.2 <0.8.0;

library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

pragma solidity >=0.6.0 <0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

pragma solidity ^0.7.0;

/**
 * @title Freeport LandData contract
 */
contract FPLandData is Ownable {
    using SafeMath for uint256;
    using SafeMath for uint;

	address _Gaia1;
	address _Gaia2;
	address _Gaia3;


    uint _sStartSort = 0;
    uint _AreaNO = 1;
    uint8 initLandType1 = 1;
    uint8 initLandType2 = 2;
    uint8 initLandType3 = 3;
    uint8 initLandType4 = 4;
	
    struct Resources{
        uint SuitableForLumber;  //0-1000
        uint SoilFertility;      //0-1000
        uint SuitableForAnimals; //0-1000
        uint WaterResources;     //0-1000
        uint MetalOres;          //0-1000
        uint SuperNaturalOres;   //0-1000
        uint EnergyOres;         //0-1000
        uint GemOres;            //0-1000
    }

    mapping (uint => Resources) public ResourcesData;	

    function Gaia1() public view virtual returns (address) {
        return _Gaia1;
    }

    function Gaia2() public view virtual returns (address) {
        return _Gaia2;
    }	

    function Gaia3() public view virtual returns (address) {
        return _Gaia3;
    }
	
    modifier onlyGaia() {
        require(Gaia1() == _msgSender() || Gaia2() == _msgSender() || Gaia3() == _msgSender() || owner() == _msgSender(), "Ownable: caller is not the Gaia");
        _;
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }

    function withdrawETH(uint _ETHWEI) public onlyOwner {
        msg.sender.transfer(_ETHWEI);
    }
	
    function setArea(uint _sAreaNO) public onlyOwner {
        _AreaNO = _sAreaNO;
    }

    function CheckAreaNO() public view returns (uint) {
		return _AreaNO;
    }
	
    function CheckStartSort() public view returns (uint) {
		return _sStartSort;
    }

    function InitLandType(uint _LandNO) public view returns(uint8 stype){
		uint XCoord = _LandNO % 100;
		uint YCoord = _LandNO / 100;
		if(XCoord < 50){
			if(YCoord < 50){
				uint RLandType = (initLandType1 + _AreaNO) % 5 + 1;
				return uint8(RLandType);
			}else{
				uint RLandType = (initLandType2 + _AreaNO) % 5 + 1;
				return uint8(RLandType);
			}
		}else{
			if(YCoord < 50){
				uint RLandType = (initLandType3 + _AreaNO) % 5 + 1;
				return uint8(RLandType);
			}else{
				uint RLandType = (initLandType4 + _AreaNO) % 5 + 1;
				return uint8(RLandType);
			}
		}
    }

    function setGaiaAddr(address _sGaia1, address _sGaia2, address _sGaia3) public onlyOwner {
        _Gaia1 = _sGaia1;
		_Gaia2 = _sGaia2;
		_Gaia3 = _sGaia3;
    }


    function InitResourcesOff() internal {
        for (uint i = 0; i < 10001; i++){
		    _initResources(i);
        }
    }

    function InitDataBatch(uint _SortNO) public onlyGaia {
        uint _start = _sStartSort;
        uint _Length = _sStartSort + _SortNO;
        for (uint i = _start; i < _Length; i++){
		    _initResources(i);
			_sStartSort += 1;
        }
    }

    function InitResourcesBatch(uint _SortStart, uint _SortEnd) public onlyGaia {
        for (uint i = _SortStart; i < _SortEnd + 1; i++){
		    _initResources(i);
        }
    }

    function _initResources(uint _tokenId) internal {
        uint8 sLandType = InitLandType(_tokenId);
		
        if(sLandType == 1){
		
            ResourcesData[_tokenId].SuitableForLumber = rand(abi.encodePacked(_tokenId, "SuitableForLumber"), 100, 700);
            ResourcesData[_tokenId].SoilFertility = rand(abi.encodePacked(_tokenId, "SoilFertility"), 100, 700);
            ResourcesData[_tokenId].SuitableForAnimals = rand(abi.encodePacked(_tokenId, "SuitableForAnimals"), 100, 700);
            ResourcesData[_tokenId].WaterResources = rand(abi.encodePacked(_tokenId, "WaterResources"), 200, 500);
            ResourcesData[_tokenId].MetalOres = rand(abi.encodePacked(_tokenId, "MetalOres"), 300, 700);
            ResourcesData[_tokenId].SuperNaturalOres = rand(abi.encodePacked(_tokenId, "SuperNaturalOres"), 500, 1000);
            ResourcesData[_tokenId].EnergyOres = rand(abi.encodePacked(_tokenId, "EnergyOres"), 300, 700);
            ResourcesData[_tokenId].GemOres = rand(abi.encodePacked(_tokenId, "GemOres"), 300, 700);

        }else if(sLandType == 2){
		
            ResourcesData[_tokenId].SuitableForLumber = rand(abi.encodePacked(_tokenId, "SuitableForLumber"), 100, 700);
            ResourcesData[_tokenId].SoilFertility = rand(abi.encodePacked(_tokenId, "SoilFertility"), 500, 1000);
            ResourcesData[_tokenId].SuitableForAnimals = rand(abi.encodePacked(_tokenId, "SuitableForAnimals"), 100, 700);
            ResourcesData[_tokenId].WaterResources = rand(abi.encodePacked(_tokenId, "WaterResources"), 700, 700);
            ResourcesData[_tokenId].MetalOres = rand(abi.encodePacked(_tokenId, "MetalOres"), 300, 700);
            ResourcesData[_tokenId].SuperNaturalOres = rand(abi.encodePacked(_tokenId, "SuperNaturalOres"), 300, 700);
            ResourcesData[_tokenId].EnergyOres = rand(abi.encodePacked(_tokenId, "EnergyOres"), 300, 700);
            ResourcesData[_tokenId].GemOres = rand(abi.encodePacked(_tokenId, "GemOres"), 500, 1000);
			
        }else if(sLandType == 3){
		
            ResourcesData[_tokenId].SuitableForLumber = rand(abi.encodePacked(_tokenId, "SuitableForLumber"), 700, 1000);
            ResourcesData[_tokenId].SoilFertility = rand(abi.encodePacked(_tokenId, "SoilFertility"), 700, 1000);
            ResourcesData[_tokenId].SuitableForAnimals = rand(abi.encodePacked(_tokenId, "SuitableForAnimals"), 700, 1000);
            ResourcesData[_tokenId].WaterResources = rand(abi.encodePacked(_tokenId, "WaterResources"), 700, 1000);
            ResourcesData[_tokenId].MetalOres = rand(abi.encodePacked(_tokenId, "MetalOres"), 300, 700);
            ResourcesData[_tokenId].SuperNaturalOres = rand(abi.encodePacked(_tokenId, "SuperNaturalOres"), 300, 700);
            ResourcesData[_tokenId].EnergyOres = rand(abi.encodePacked(_tokenId, "EnergyOres"), 300, 700);
            ResourcesData[_tokenId].GemOres = rand(abi.encodePacked(_tokenId, "GemOres"), 300, 700);
			
        }else if(sLandType == 4){
		
            ResourcesData[_tokenId].SuitableForLumber = rand(abi.encodePacked(_tokenId, "SuitableForLumber"), 100, 700);
            ResourcesData[_tokenId].SoilFertility = rand(abi.encodePacked(_tokenId, "SoilFertility"), 100, 700);
            ResourcesData[_tokenId].SuitableForAnimals = rand(abi.encodePacked(_tokenId, "SuitableForAnimals"), 100, 700);
            ResourcesData[_tokenId].WaterResources = rand(abi.encodePacked(_tokenId, "WaterResources"), 700, 1000);
            ResourcesData[_tokenId].MetalOres = rand(abi.encodePacked(_tokenId, "MetalOres"), 400, 800);
            ResourcesData[_tokenId].SuperNaturalOres = rand(abi.encodePacked(_tokenId, "SuperNaturalOres"), 400, 800);
            ResourcesData[_tokenId].EnergyOres = rand(abi.encodePacked(_tokenId, "EnergyOres"), 400, 800);
            ResourcesData[_tokenId].GemOres = rand(abi.encodePacked(_tokenId, "GemOres"), 400, 800);
			
        }else if(sLandType == 5){
		
            ResourcesData[_tokenId].SuitableForLumber = rand(abi.encodePacked(_tokenId, "SuitableForLumber"), 100, 700);
            ResourcesData[_tokenId].SoilFertility = rand(abi.encodePacked(_tokenId, "SoilFertility"), 100, 700);
            ResourcesData[_tokenId].SuitableForAnimals = rand(abi.encodePacked(_tokenId, "SuitableForAnimals"), 100, 700);
            ResourcesData[_tokenId].WaterResources = rand(abi.encodePacked(_tokenId, "WaterResources"), 800, 1000);
            ResourcesData[_tokenId].MetalOres = rand(abi.encodePacked(_tokenId, "MetalOres"), 800, 1000);
            ResourcesData[_tokenId].SuperNaturalOres = rand(abi.encodePacked(_tokenId, "SuperNaturalOres"), 400, 700);
            ResourcesData[_tokenId].EnergyOres = rand(abi.encodePacked(_tokenId, "EnergyOres"), 800, 1000);
            ResourcesData[_tokenId].GemOres = rand(abi.encodePacked(_tokenId, "GemOres"), 400, 700);

        }
    }

    function setResourcesDataGaia(
        uint _tokenId,
        uint _sSuitableForLumber,
        uint _sSoilFertility,
        uint _sSuitableForAnimals,
        uint _sWaterResources,
        uint _sMetalOres,
        uint _sSuperNaturalOres,
        uint _sEnergyOres,
        uint _sGemOres
	) public onlyGaia {
        ResourcesData[_tokenId].SuitableForLumber = _sSuitableForLumber;
        ResourcesData[_tokenId].SoilFertility = _sSoilFertility;
        ResourcesData[_tokenId].SuitableForAnimals = _sSuitableForAnimals;
        ResourcesData[_tokenId].WaterResources = _sWaterResources;
        ResourcesData[_tokenId].MetalOres = _sMetalOres;
        ResourcesData[_tokenId].SuperNaturalOres = _sSuperNaturalOres;
        ResourcesData[_tokenId].EnergyOres = _sEnergyOres;
        ResourcesData[_tokenId].GemOres = _sGemOres;
    }

    function setResourcesData(
        uint _tokenId,
        uint _sSuitableForLumber,
        uint _sSoilFertility,
        uint _sSuitableForAnimals,
        uint _sWaterResources,
        uint _sMetalOres,
        uint _sSuperNaturalOres,
        uint _sEnergyOres,
        uint _sGemOres
	) internal {
        ResourcesData[_tokenId].SuitableForLumber = _sSuitableForLumber;
        ResourcesData[_tokenId].SoilFertility = _sSoilFertility;
        ResourcesData[_tokenId].SuitableForAnimals = _sSuitableForAnimals;
        ResourcesData[_tokenId].WaterResources = _sWaterResources;
        ResourcesData[_tokenId].MetalOres = _sMetalOres;
        ResourcesData[_tokenId].SuperNaturalOres = _sSuperNaturalOres;
        ResourcesData[_tokenId].EnergyOres = _sEnergyOres;
        ResourcesData[_tokenId].GemOres = _sGemOres;
    }

    function setResourcesSort(uint _tokenId, uint _Sort, uint _Data) public onlyGaia {
        if(_Sort == 1){
        	ResourcesData[_tokenId].SuitableForLumber = _Data;
        }else if(_Sort == 2){
	        ResourcesData[_tokenId].SoilFertility = _Data;
        }else if(_Sort == 3){
	        ResourcesData[_tokenId].SuitableForAnimals = _Data;
        }else if(_Sort == 4){
	        ResourcesData[_tokenId].WaterResources = _Data;
        }else if(_Sort == 5){
	        ResourcesData[_tokenId].MetalOres = _Data;
        }else if(_Sort == 6){
	        ResourcesData[_tokenId].SuperNaturalOres = _Data;
        }else if(_Sort == 7){
	        ResourcesData[_tokenId].EnergyOres = _Data;
        }else if(_Sort == 8){
	        ResourcesData[_tokenId].GemOres = _Data;
        }
    }

    function setResourcesInternal(uint _tokenId, uint _Sort, uint _Data) internal {
        if(_Sort == 1){
        	ResourcesData[_tokenId].SuitableForLumber = _Data;
        }else if(_Sort == 2){
	        ResourcesData[_tokenId].SoilFertility = _Data;
        }else if(_Sort == 3){
	        ResourcesData[_tokenId].SuitableForAnimals = _Data;
        }else if(_Sort == 4){
	        ResourcesData[_tokenId].WaterResources = _Data;
        }else if(_Sort == 5){
	        ResourcesData[_tokenId].MetalOres = _Data;
        }else if(_Sort == 6){
	        ResourcesData[_tokenId].SuperNaturalOres = _Data;
        }else if(_Sort == 7){
	        ResourcesData[_tokenId].EnergyOres = _Data;
        }else if(_Sort == 8){
	        ResourcesData[_tokenId].GemOres = _Data;
        }
    }

    function CheckResources(uint _tokenId) public view returns (uint[] memory) {
		uint[] memory getResources = new uint[](8);
		getResources[0] = ResourcesData[_tokenId].SuitableForLumber;
		getResources[1] = ResourcesData[_tokenId].SoilFertility;
		getResources[2] = ResourcesData[_tokenId].SuitableForAnimals;
		getResources[3] = ResourcesData[_tokenId].WaterResources;
		getResources[4] = ResourcesData[_tokenId].MetalOres;
		getResources[5] = ResourcesData[_tokenId].SuperNaturalOres;
		getResources[6] = ResourcesData[_tokenId].EnergyOres;
		getResources[7] = ResourcesData[_tokenId].GemOres;
		return getResources;
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
}