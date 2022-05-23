
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

    uint256 public LandPrice = 500 * 10 ** uint(18);
	
	uint256 public ActiveTime = 1651068000;   //1651240800 = Fri Apr 29 2022 22:00:00 UTC+0800

    bool public saleIsActive = true;
    bool public MTCMintRewardIsActive = true;
    bool public SSBMintRewardIsActive = true;

	address _FPLandAddr = 0x8B52b2237a1dFA0ad4533BEF61236d936DE19417;
	address _InitLandTypeAddr = 0xdFD9c85ef14AA7647876a2D6B1f8eD31e880E1eD;
	address _SSBIDAddr = 0x7DF819ad191248BD65A848A110c59F1957E8C1C7;
	address _FPCitizenAddr = 0x69AF985F63B1937F3C96a671F523b8c96eEBFbdA;
	address _FPAssetsAddr = 0xA297E00F923adFeB21F00E730f07042Eb40B95F7;
	address _FPAssetsPAddr = 0x027b5bc111f375AC858d9D51F0B50a3d791C31E5;
	address _MTCAddr = 0x5F1D2cfDEB097B83eD2f35Cf3E827DE2b700F05a;
	address _Gaia1;
	address _Gaia2;
	address _Gaia3;

    uint8 public MTCRewardTypeID = 16;
    uint8 public MTCRewardRarityID = 1;
    uint8 public SSBRewardTypeID =   18;
    uint8 public SSBRewardRarityID =   3;
    uint8 public SSBIDNO = 15;

    uint public SSBLandRateA = 250;
    uint public SSBLandRateB = 1250;

	mapping (uint8 => uint) MinterRate;
	mapping (uint8 => uint) LandARAProfit;
	mapping (uint => mapping (uint => bool)) public LIsLandNOMinted;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);

		MinterRate[0] = 0;
		MinterRate[1] = 20;
		MinterRate[2] = 50;
		MinterRate[3] = 75;
		
		LandARAProfit[6] = 10;
		LandARAProfit[7] = 5;
		LandARAProfit[8] = 1;
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

	function setTime(uint256 _ActiveTime) public onlyOwner{
        ActiveTime = _ActiveTime;
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

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }
	
    function flipMTCMintReward() public onlyOwner {
        MTCMintRewardIsActive = !MTCMintRewardIsActive;
    }
	
    function flipSSBMintReward() public onlyOwner {
        SSBMintRewardIsActive = !SSBMintRewardIsActive;
    }
	
    function CheckAreaMintable(uint _AreaNO) public view returns (bool) {
		return  FPLD(_FPLandAddr).CheckAreaMintable(_AreaNO);
    }

    function setMintReward(uint8 _MTCRewardTypeID, uint8 _MTCRewardRarityID, uint8 _SSBRewardTypeID, uint8 _SSBRewardRarityID ,uint8 _SSBIDNO) public onlyOwner {
        MTCRewardTypeID = _MTCRewardTypeID;
        MTCRewardRarityID = _MTCRewardRarityID;
        SSBRewardTypeID =   _SSBRewardTypeID;
        SSBRewardRarityID =   _SSBRewardRarityID;
		SSBIDNO =   _SSBIDNO;
    }
	
    function CheckMintReward() public view returns (uint8[] memory) {
		uint8[] memory getMintReward = new uint8[](4);
		getMintReward[0] = MTCRewardTypeID;
		getMintReward[1] = MTCRewardRarityID;
		getMintReward[2] = SSBRewardTypeID;
		getMintReward[3] = SSBRewardRarityID;
		return getMintReward;
    }
	
    function GaiaMintReward(address _Addr, uint8 _type, uint8 _MinterType) internal {
		uint LDtotalSupply = FPLD(_FPLandAddr).totalSupply();
		if(_type == 1 && IsMTCMintReward()){
			bytes memory seed = abi.encodePacked(block.timestamp.add(LDtotalSupply));
			uint drawNO = rand(seed, 1, 100);
			if(drawNO <= MinterRate[_MinterType]){
				FreeURI(_FPAssetsPAddr).GaiaMint(_Addr, MTCRewardTypeID + 1, MTCRewardRarityID + 1);
			}else{
				FreeURI(_FPAssetsPAddr).GaiaMint(_Addr, MTCRewardTypeID, MTCRewardRarityID);
			}
		}else if(_type == 2 && IsSSBMintReward()){
			bytes memory seed = abi.encodePacked(block.timestamp.add(LDtotalSupply));
			uint drawNO = rand(seed, 1, 100);
			if(drawNO <= MinterRate[_MinterType]){
				FreeURI(_FPAssetsPAddr).GaiaMint(_Addr, SSBRewardTypeID + 1, SSBRewardRarityID + 1);
			}else{
				FreeURI(_FPAssetsPAddr).GaiaMint(_Addr, SSBRewardTypeID, SSBRewardRarityID);
			}
		}
    }

    function SSBLandType() internal view returns (uint8) {
		uint LDtotalSupply = FPLD(_FPLandAddr).totalSupply();
		bytes memory seed = abi.encodePacked(block.timestamp.add(LDtotalSupply));
		uint drawNO = rand(seed, 1, 10000);
		uint8 _SSBLandType = 8;

		if(drawNO <= SSBLandRateA){
			_SSBLandType = 6;
		}else if(drawNO <= SSBLandRateB && drawNO > SSBLandRateA){
			_SSBLandType = 7;
		}
		
		return _SSBLandType;
    }
	
    function setSSBLandRate(uint _RateA ,uint _RateB) public onlyOwner {
        SSBLandRateA = _RateA;
        SSBLandRateB = _RateB;
    }

    function CheckMinterRate() public view returns (uint[] memory) {
		uint[] memory getMinterRate = new uint[](3);
		getMinterRate[0] = MinterRate[1];
		getMinterRate[1] = MinterRate[2];
		getMinterRate[2] = MinterRate[3];
		return getMinterRate;
    }

    function setMinterRate(uint8 _MinterType, uint _MinterRate) public onlyOwner {
        MinterRate[_MinterType] = _MinterRate;
    }

    function IsLandMinted(uint _AreaNO, uint _LandNO) public view returns (bool) {
        return FPLD(_FPLandAddr).IsLandMinted(_AreaNO, _LandNO);
    }

    function CheckMintedBatch(uint _AreaNO, uint[] memory _LandNO) public view returns (bool[] memory) {
        uint _LandNOLength = _LandNO.length;

		bool[] memory getCheckMinted = new bool[](_LandNOLength);
        for (uint i = 0; i < _LandNOLength; i++){
		    getCheckMinted[i] = FPLD(_FPLandAddr).IsLandMinted(_AreaNO, _LandNO[i]);
        }
        return getCheckMinted;
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

    function CheckLandPrice() public view returns (uint) {
        return LandPrice;
    }

    function setLandPrice(uint _amontsMTC) public onlyGaia {
        LandPrice = _amontsMTC * 10 ** 18;
    }

    function setTraitDataGaia(uint _tokenID, uint8 stype, address ArinaChain, uint _AreaNO, uint _LandNO, uint _CoordinateX, uint _CoordinateY, uint _ARADailyProfit) public onlyGaia {
        FPLD(_FPLandAddr).setTraitDataGaia(_tokenID, stype, ArinaChain, _AreaNO, _LandNO, _CoordinateX, _CoordinateY, _ARADailyProfit);
    }

    /**
    * Mint Freeport Land MTC
    */
    function mintLandMTC(uint _AreaNO, uint _LandNO) public {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");
        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
        require(_LandNO >= 0 && _LandNO < 10000, "LandNO error.");
        require(!IsLandMinted(_AreaNO, _LandNO), "Sale must be active to mint Freeport Land");
        address inputAddr = msg.sender;
        require(FreeURI(_MTCAddr).transferFrom(inputAddr, address(this), LandPrice), "Freeport Land Mint : Value error.");
		
		uint8 _MinterType = CheckMinterType(inputAddr);
		uint8 _sLandType = FreeURI(_InitLandTypeAddr).InitLandType(_AreaNO, _LandNO);
		
		FPLD(_FPLandAddr).FPLandMint(inputAddr, _AreaNO, _LandNO, _sLandType);
		GaiaMintReward(inputAddr, 1, _MinterType);
    }
	
    function mintLandMTCBatch(uint _AreaNO, uint[] memory _LandNO) public {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");
        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
		
        uint _LandNOLength = _LandNO.length;
        for (uint i = 0; i < _LandNOLength; i++){
		    require(_LandNO[i] >= 0 && _LandNO[i] < 10000, "LandNO error.");
		    require(!IsLandMinted(_AreaNO, _LandNO[i]), "Sale must be active to mint Freeport Land");
        }
		
        address inputAddr = msg.sender;
        require(FreeURI(_MTCAddr).transferFrom(inputAddr, address(this), LandPrice.mul(_LandNOLength)), "Freeport Land Mint : Value error.");
		uint8 _MinterType = CheckMinterType(inputAddr);
		
        for (uint i = 0; i < _LandNOLength; i++){
		    mintLandInternal(_AreaNO, _LandNO[i], inputAddr, _MinterType);
        }
    }
	
    function mintLandInternal(uint _AreaNO, uint _LandNO, address inputAddr, uint8 _MinterType) internal {
		uint8 _sLandType = FreeURI(_InitLandTypeAddr).InitLandType(_AreaNO, _LandNO);

		FPLD(_FPLandAddr).FPLandMint(inputAddr, _AreaNO, _LandNO, _sLandType);
		GaiaMintReward(inputAddr, 1, _MinterType);
    }


    /**
    * Mint Freeport Land SSB
    */
    function mintLandSSB(uint _AreaNO, uint _LandNO) public {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");

        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
        require(_LandNO >= 0 && _LandNO < 10000, "LandNO error.");
        require(!IsLandMinted(_AreaNO, _LandNO), "Sale must be active to mint Freeport Land");
        address inputAddr = msg.sender;
        require(CheckSSBAmounts(inputAddr) > 0, "SSB amounts error.");

		uint256 SSBtokenId = CheckFirstSSB(inputAddr);
		
		FPAS(_FPAssetsAddr).transferFrom(inputAddr, address(this), SSBtokenId);
		
		uint8 _MinterType = CheckMinterType(inputAddr);
		uint8 _sLandType = SSBLandType();
		
		FPLD(_FPLandAddr).FPLandMint(inputAddr, _AreaNO, _LandNO, _sLandType);
		GaiaMintReward(inputAddr, 2, _MinterType);

    }

	
    function mintLandSSBBatch(uint _AreaNO, uint[] memory _LandNO) public {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");
        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
		
        uint _LandNOLength = _LandNO.length;
        for (uint i = 0; i < _LandNOLength; i++){
		    require(_LandNO[i] >= 0 && _LandNO[i] < 10000, "LandNO error.");
		    require(!IsLandMinted(_AreaNO, _LandNO[i]), "Sale must be active to mint Freeport Land");
        }
		
        address inputAddr = msg.sender;
        require(CheckSSBAmounts(inputAddr) >= _LandNOLength, "SSB amounts error.");
		uint8 _MinterType = CheckMinterType(inputAddr);
		
		uint[] memory getSSBArray = new uint[](_LandNOLength);
		getSSBArray = CheckSSBArray(inputAddr, _LandNOLength);
		
        for (uint i = 0; i < _LandNOLength; i++){
		    FPAS(_FPAssetsAddr).transferFrom(inputAddr, address(this), getSSBArray[i]);
		    mintSSBInternal(_AreaNO, _LandNO[i], inputAddr, _MinterType);
        }
    }
	
    function mintSSBInternal(uint _AreaNO, uint _LandNO, address inputAddr, uint8 _MinterType) internal {
		uint8 _sLandType = SSBLandType();

		FPLD(_FPLandAddr).FPLandMint(inputAddr, _AreaNO, _LandNO, _sLandType);
		GaiaMintReward(inputAddr, 2, _MinterType);
    }

    function GaiaMintLand(address inputAddr, uint _AreaNO, uint _LandNO) public onlyGaia {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");
        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
        require(_LandNO >= 0 && _LandNO < 10000, "LandNO error.");
        require(!IsLandMinted(_AreaNO, _LandNO), "Sale must be active to mint Freeport Land");

		uint8 _sLandType = FreeURI(_InitLandTypeAddr).InitLandType(_AreaNO, _LandNO);
		FPLD(_FPLandAddr).FPLandMint(inputAddr, _AreaNO, _LandNO, _sLandType);
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
	
    function IsMTCMintReward() public view returns (bool) {
        return MTCMintRewardIsActive;
    }
	
    function IsSSBMintReward() public view returns (bool) {
        return SSBMintRewardIsActive;
    }
	
    function IsTimeActive() public view returns (bool) {
        return block.timestamp >= ActiveTime;
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
	
    function CheckCSbalanceOf(address addr) public view returns (uint256 tokenbalanceOf) {
        return FreeURI(_FPCitizenAddr).balanceOf(addr);
    }
	
    function ChecktokenIDOfOwner(address addr, uint256 index) public view returns (uint256 tokenId) {
        return FreeURI(_FPCitizenAddr).tokenOfOwnerByIndex(addr, index);
    }
	
    function ChecktokenIDType(uint256 _tokenID) public view returns (uint8) {
        (uint8 Xtype, , , , ) = FreeURI(_FPCitizenAddr).CheckTraitData(_tokenID);
        return Xtype;
    }
	
    function CheckMinterType(address addr) public view returns (uint8) {
        uint256 tokenbalanceOf = FreeURI(_FPCitizenAddr).balanceOf(addr);
		uint8 _MinterType = 0;

        for (uint i = 0; i < tokenbalanceOf; i++){
		    uint tokenIDReturn = FreeURI(_FPCitizenAddr).tokenOfOwnerByIndex(addr, i);
			(uint8 Xtype, , , , ) = FreeURI(_FPCitizenAddr).CheckTraitData(tokenIDReturn); 
			
			if(Xtype > _MinterType){
				_MinterType = Xtype;
			}
        }
        return _MinterType;
    }
	
    function CheckAssetsbalanceOf(address addr) public view returns (uint256 tokenbalanceOf) {
        return FPAS(_FPAssetsAddr).balanceOf(addr);
    }
	
    function ChecktokenIDOfAssets(address addr, uint256 index) public view returns (uint256 tokenId) {
        return FPAS(_FPAssetsAddr).tokenOfOwnerByIndex(addr, index);
    }

    function CheckIsSSBID(uint256 _tokenID) public view returns (bool) {
        bool _IsSSBID = FPAS(_SSBIDAddr).GetSSBtokenID(_tokenID);
        return _IsSSBID;
    }

    function CheckSSBAmounts(address addr) public view returns (uint256) {
        uint256 tokenbalanceOf = FPAS(_FPAssetsAddr).balanceOf(addr);
		uint256 _SSBAmounts = 0;

        for (uint i = 0; i < tokenbalanceOf; i++){
		    uint tokenIDReturn = FPAS(_FPAssetsAddr).tokenOfOwnerByIndex(addr, i);
			bool _IsSSBID = FPAS(_SSBIDAddr).GetSSBtokenID(tokenIDReturn); 
			
			if(_IsSSBID){
				_SSBAmounts += 1;
			}
        }
        return _SSBAmounts;
    }
	
    function CheckFirstSSB(address addr) public view returns (uint256) {

        uint256 tokenbalanceOf = FPAS(_FPAssetsAddr).balanceOf(addr);
		uint256 _FirstSSBID = 0;

        for (uint i = 0; i < tokenbalanceOf; i++){
		    uint256 tokenIDReturn = FPAS(_FPAssetsAddr).tokenOfOwnerByIndex(addr, i);
			bool _IsSSBID = FPAS(_SSBIDAddr).GetSSBtokenID(tokenIDReturn); 
			
			if(_IsSSBID){
				return tokenIDReturn;
			}
        }
    }

    function CheckSSBArray(address addr, uint _Array) public view returns (uint[] memory) {
		uint[] memory getSSBArray = new uint[](_Array);
        uint256 tokenbalanceOf = FPAS(_FPAssetsAddr).balanceOf(addr);
		uint _SSBSort = 0;

        for (uint i = 0; i < tokenbalanceOf; i++){
		    uint256 tokenIDReturn = FPAS(_FPAssetsAddr).tokenOfOwnerByIndex(addr, i);
			bool _IsSSBID = FPAS(_SSBIDAddr).GetSSBtokenID(tokenIDReturn); 

			if(_IsSSBID){
				getSSBArray[_SSBSort] = tokenIDReturn;
				_SSBSort += 1;
				
				if(_SSBSort >= _Array){
					return getSSBArray;
				}
			}
        }
    }
}