
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

interface FreeURI{
    function GaiaMint(address _Addr, uint8 _typeID, uint8 _rarityID) external;
    function GettokenURI(uint _typeID) external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
	
	function InitLandType(uint _AreaNO, uint _LandNO) external view returns (uint8);
	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
	function CheckTraitData(uint tokenId) external view returns (uint8 stype, uint publicMTC, uint redeemMTC, address ArinaChain, uint CitizensQuota);
}

interface FPAS{
    function GaiaMint(address _Addr, uint8 _typeID, uint8 _rarityID) external;
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 tokenId) external;
	function GetSSBtokenID(uint _tokenID) external view returns (bool);
	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
	function CheckTraitData(uint tokenId) external view returns (uint8 stype, uint8 srarity);
}

interface FPLD{
    function GaiaMint(address _Addr, uint8 _typeID, uint8 _rarityID) external;
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transferFrom(address from, address to, uint256 tokenId) external;
	function GetSSBtokenID(uint _tokenID) external view returns (bool);
	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
	function CheckAreaMintable(uint _AreaNO) external view returns (bool);
	function IsLandMinted(uint _AreaNO, uint _LandNO) external view returns (bool);
	function checkLandTypeByLandNO(uint _AreaNO, uint _LandNO) external view returns (uint8 sType);

	function CheckTraitData(uint tokenId) external view returns (
		uint8 stype,
		address ArinaChain,
		uint _AreaNO,
		uint _LandNO,
		uint _CoordinateX,
		uint _CoordinateY,
		uint _ARADailyProfit
	);
	function setTraitDataGaia(uint _tokenID, uint8 stype, address ArinaChain, uint _AreaNO, uint _LandNO, uint _CoordinateX, uint _CoordinateY, uint _ARADailyProfit) external;
	function FPLandMint(address _Addr, uint _AreaNO, uint _LandNO, uint8 _sLandType) external;
}

pragma solidity ^0.7.0;

/**
 * @title Freeport LandNFT Mint contract
 */
contract FPLandNFTMint is Context {
    using SafeMath for uint256;
    using SafeMath for uint;
    address private _owner;

	address _FPLandAddr = 0xE1271a4DB8a4Cc3f9fc90bec99443C3D0a3D5705;
	address _InitLandTypeAddr = 0xdFD9c85ef14AA7647876a2D6B1f8eD31e880E1eD;
	address _SSBIDAddr = 0x7DF819ad191248BD65A848A110c59F1957E8C1C7;
	address _FPCitizenAddr = 0x69AF985F63B1937F3C96a671F523b8c96eEBFbdA;
	address _FPAssetsAddr = 0xA297E00F923adFeB21F00E730f07042Eb40B95F7;
	address _FPAssetsPAddr = 0x027b5bc111f375AC858d9D51F0B50a3d791C31E5;
	address _MTCAddr = 0x5F1D2cfDEB097B83eD2f35Cf3E827DE2b700F05a;
	address _Gaia1;
	address _Gaia2;
	address _Gaia3;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
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
        uint _thisTokenBalance = FreeURI(tokenAddr).balanceOf(address(this));
        require(FreeURI(tokenAddr).transfer(msg.sender, _thisTokenBalance));
    }

    function withdrawNFTTokens(address NFTAddr, uint _tokenID) external onlyOwner{
		FPAS(NFTAddr).transferFrom(address(this), msg.sender, _tokenID);
    }

    function setURIAddr(address _sInitLandTypeAddr, address _sSSBIDAddr) public onlyOwner {
		_InitLandTypeAddr = _sInitLandTypeAddr;
		_SSBIDAddr = _sSSBIDAddr;
    }

    function setFPAddr(address _sFPCitizenAddr, address _sFPAssetsAddr, address _sFPAssetsPAddr,  address _sFPLandAddr, address _sMTCAddr) public onlyOwner {
		_FPCitizenAddr = _sFPCitizenAddr;
		_FPAssetsAddr = _sFPAssetsAddr;
		_FPAssetsPAddr = _sFPAssetsPAddr;
		_FPLandAddr = _sFPLandAddr;
        _MTCAddr = _sMTCAddr;
    }

    function setGaiaAddr(address _sGaia1, address _sGaia2, address _sGaia3) public onlyOwner {
        _Gaia1 = _sGaia1;
		_Gaia2 = _sGaia2;
		_Gaia3 = _sGaia3;
    }

    function setTraitDataGaia(uint _tokenID, uint8 stype, address ArinaChain, uint _AreaNO, uint _LandNO, uint _CoordinateX, uint _CoordinateY, uint _ARADailyProfit) public onlyGaia {
        FPLD(_FPLandAddr).setTraitDataGaia(_tokenID, stype, ArinaChain, _AreaNO, _LandNO, _CoordinateX, _CoordinateY, _ARADailyProfit);
    }


    function CheckLandIncome(uint _tokenID) public view returns (uint) {
		(, , , , , , uint _sARADailyProfit) = FPLD(_FPLandAddr).CheckTraitData(_tokenID);
		return  _sARADailyProfit;
    }

    function CheckMintedBatch(uint _IDStart, uint _IDEnd) public view returns (uint[] memory) {
        require(_IDEnd > _IDStart, "ID error.");
        uint _IDLength = _IDEnd - _IDStart + 1;

		uint[] memory getLandIncome = new uint[](_IDLength);
        for (uint i = 0; i < _IDLength; i++){
		    getLandIncome[i] = CheckLandIncome(_IDStart + i);
        }
        return getLandIncome;
    }

    function checkLandTypeByID(uint tokenId) public view returns (
		uint8 stype
	) {
		(uint8 Xtype, , , , , , ) = FPLD(_FPLandAddr).CheckTraitData(tokenId);
        return Xtype;
    }
	
    function checkLandTypeByLandNO(uint _AreaNO, uint _LandNO) public view returns (
		uint8 stype
	) {
        return FPLD(_FPLandAddr).checkLandTypeByLandNO(_AreaNO, _LandNO);
    }
	
    function CheckTraitData(uint tokenId) public view returns (
		uint8 stype,
		address ArinaChain,
		uint _AreaNO,
		uint _LandNO,
		uint _CoordinateX,
		uint _CoordinateY,
		uint _ARADailyProfit
	) {
        return FPLD(_FPLandAddr).CheckTraitData(tokenId);
    }

}