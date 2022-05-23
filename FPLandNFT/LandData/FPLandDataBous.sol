
// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol

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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface FPLD{
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function totalSupply() external view returns (uint256);
	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

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
	) external;

	function CheckResources(uint _tokenId) external view returns (uint[] memory);
}

pragma solidity ^0.7.0;

/**
 * @title Freeport Land Data Proxy contract
 */
contract FPLandDataProxy is Context {
    using SafeMath for uint256;
    using SafeMath for uint;
	
    address private _owner;
	
    uint _sStartSort = 0;
	address _Gaia1;
	address _Gaia2;
	address _Gaia3;

	mapping (uint => uint) FPLandAreaNO;
	mapping (uint => uint) FPLandLandNO;
	mapping (uint => address) FPLandDataAddress;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);

		FPLandDataAddress[1] = 0x8C4d3aBC1CFC17eFc04497833e0C58aB3cA584F1;
		FPLandDataAddress[2] = 0x7C5bbA8360D295b161accD8f234BbFd34a857A33;
		FPLandDataAddress[3] = 0x713c6733b1931508A5D506695192302cFD5c530C;
		FPLandDataAddress[4] = 0x3cd9647155ca5471695EDaB805E0DEfee0A2A184;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
	
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

    function takeTokensToManager(address tokenAddr) external onlyOwner{
        uint _thisTokenBalance = FPLD(tokenAddr).balanceOf(address(this));
        require(FPLD(tokenAddr).transfer(msg.sender, _thisTokenBalance));
    }
	
    function CheckLandDataAddress(uint _Sort) public view returns (address) {
		return FPLandDataAddress[_Sort];
    }
	
    function setLandDataReward(uint _AreaNO ,uint _LandNO) public onlyOwner {
	
		LandDataReward(_AreaNO, _LandNO);
		_sStartSort += 1;
		FPLandAreaNO[_sStartSort] = _AreaNO;
		FPLandLandNO[_sStartSort] = _LandNO;
    }
	
    function LandDataReward(uint _AreaNO, uint _LandNO) internal {
	
		uint[] memory getResources = new uint[](8);
		getResources = FPLD(FPLandDataAddress[_AreaNO]).CheckResources(_LandNO);
		getResources[0] += getResources[0].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "SuitableForLumber"), 5, 10)).div(100);
		getResources[1] += getResources[1].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "SoilFertility"), 5, 10)).div(100);
		getResources[2] += getResources[2].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "SuitableForAnimals"), 5, 10)).div(100);
		getResources[3] += getResources[3].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "WaterResources"), 5, 10)).div(100);
		getResources[4] += getResources[4].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "MetalOres"), 5, 10)).div(100);
		getResources[5] += getResources[5].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "SuperNaturalOres"), 5, 10)).div(100);
		getResources[6] += getResources[6].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "EnergyOres"), 5, 10)).div(100);
		getResources[7] += getResources[7].mul(rand(abi.encodePacked(_LandNO + block.timestamp, "GemOres"), 5, 10)).div(100);
	
        for (uint i = 0; i < 8; i++){
		    if(getResources[i] > 1000){
				getResources[i] = 1000;
			}
        }
			
        FPLD(FPLandDataAddress[_AreaNO]).setResourcesDataGaia(
		_LandNO,
		getResources[0],
		getResources[1],
		getResources[2],
		getResources[3],
		getResources[4],
		getResources[5],
		getResources[6],
		getResources[7]);
    }


    function LandDataRewardBatch( uint[] memory _AreaNO, uint[] memory _LandNO) public onlyOwner {
        require(_AreaNO.length == _LandNO.length, "AreaNO length error.");
        uint _LandNOLength = _LandNO.length;

        for (uint i = 0; i < _LandNOLength; i++){
		    LandDataReward(_AreaNO[i], _LandNO[i]);
		    _sStartSort += 1;
		    FPLandAreaNO[_sStartSort] = _AreaNO[i];
		    FPLandLandNO[_sStartSort] = _LandNO[i];
        }
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