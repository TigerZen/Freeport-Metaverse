pragma solidity >= 0.5.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

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

library useDecimal{
    using uintTool for uint;

    function m278(uint n) internal pure returns(uint){
        return n.mul(278)/1000;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
}

interface IFreeport{
    function GetRandomName(uint8 Gender) external view returns(string memory firstName, string memory lastName);
}

contract AICitizenContract is math{
    using Address for address;
    function() external payable{}
	
    address public worldWill = 0xE34BdA906dDfa623a388bCa0BD343B764187f325;
    address public manager;
    string public CitizenfirstName;
    string public CitizenlastName;
	
    address _dexAddr = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;     //PancakeRouter address.
	address _secretary = 0x3C7Ba96F1F62081Fcb7AF0bFF4583d198ed660d6;   //Secretary address.
    address _MTCAddr = 0x4603b8d2e98B8Fbafe8A0CDe4F4381bBAB345c8b;     //MTC token contract address.
    address _FPDAddr = 0xa42bDcdfb8c717a9E8b58131640F2661Bf81620E;     //FPD token contract address.

    address _WoodAddr = 0x1Cb9DB4b6da87712695b1920060e0fC233F77175;    //Wood token contract address.
    address _StoneAddr = 0x397188b11eFCc14Fc579992d0983000D2B54e439;   //Stone token contract address.
    address _OreAddr = 0x8cBcd4e136563C38Ec534878D9C201421D43BaF0;     //Ore token contract address.
    address _WaterAddr = 0x6Eea93D4B0e6D9580e44Ef16b2C805F313852Dd2;   //Water token contract address.
    address _FoodAddr = 0x4efDE112638d8fC6cE9CE57Bd8a908cC02b5460D;    //Food token contract address.
    address _FPName = 0xF8051b865689052fCB635e2276B7bafE66B8041A;      //Get name contract address.
	
	uint public bargainingRate = 2000; // 20% Bargaining Rate
	uint public tradeTaxFee = 500;     // 5% Tax

    address[] familiarList;

    constructor(address _creator) public{
        manager = _creator;
		setRandomCitizenName();
		
		
		emit OwnershipTransferred(address(0), _creator);
    }

    struct CitizenInfo {
        uint IsReg;
        uint TalkTime;
        uint Friendliness;
        uint TradingAmount;
    }

    mapping(address => CitizenInfo) public citizenInfos;

    event setFamiliarResult(address _userAddr, bool result);
    event TalkResult(address _userAddr,uint _FriendResult, bool result);
	event swapETokensForTokens(uint _amountsIn, uint _amountsOut, uint8 _tokenIN, uint8 _tokenOUT);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
	
	//----------------Freeport WorldWill manager Function----------------------------
    modifier onlyWorldWill{
        require(msg.sender == manager || msg.sender == worldWill, "Sender is not worldWill");
        _;
    }

    function changeManager(address _new_manager) public {
        require(msg.sender == worldWill, "Sender is not worldWill");
        manager = _new_manager;
    }

    function withdraw() external onlyWorldWill{
        (msg.sender).transfer(address(this).balance);
    }

    function withdrawfrom(uint amount) external onlyWorldWill{
	    require(address(this).balance >= amount, "Insufficient balance");
        (msg.sender).transfer(amount);
    }

    function takeTokensToManager(address tokenAddr) external onlyWorldWill{
        uint _thisTokenBalance = IERC20(tokenAddr).balanceOf(address(this));
        require(IERC20(tokenAddr).transfer(msg.sender, _thisTokenBalance));
    }

	function destroy() external onlyWorldWill{ 
        selfdestruct(msg.sender); 
	}
	
	//----------------Freeport Function----------------------------
    function setFee(uint amountRate, uint amountTax) public onlyWorldWill{
        bargainingRate = amountRate;
		tradeTaxFee = amountTax;
    }
	
	//--Set to AI citizen's familiar list--//
    function setFamiliar(address Useradder) internal {
		require(citizenInfos[Useradder].IsReg == 0, "Freeport : This address has been registered.");
		require(!isFamiliar(Useradder), "Freeport : This address is in list.");
		
		citizenInfos[Useradder].IsReg = 1;
		citizenInfos[Useradder].TalkTime = now.sub(86400);
		citizenInfos[Useradder].Friendliness = 1000;
		citizenInfos[Useradder].TradingAmount = 0;

		familiarList.push(Useradder);
		emit setFamiliarResult(Useradder, true);
    }
	
	//--Citizen Talk in Freeport--//
    function CitizenTalk() external {
		address Useradder = msg.sender;
		if(!isFamiliar(Useradder)){
			setFamiliar(Useradder);
		}
		require(inqTalkRecover(Useradder) >= 86400, "Freeport : The TalkTime recovery period is not over yet.");
		
		uint _wFriendResult = _random(block.number, 0, 10);
		if(citizenInfos[Useradder].Friendliness.add(_wFriendResult) > 2000){
			citizenInfos[Useradder].Friendliness = 2000;
		}else{
			citizenInfos[Useradder].Friendliness = citizenInfos[Useradder].Friendliness.add(_wFriendResult);
		}
		citizenInfos[Useradder].TalkTime = now;
		emit TalkResult(Useradder, _wFriendResult, true);
    }

	//--Swap Exact token to Exact--//
    function swapExactTokensForTokens(uint8 _tokenIN, uint8 _tokenOUT, uint _tradeAmount) external {
		require(isFamiliar(msg.sender), "Freeport : This this address is not in familiar list.");
		require(IERC20(getTokenAddr(_tokenIN)).transferFrom(msg.sender, address(this), _tradeAmount), "User's value error.");
		uint[] memory TokenPrice = new uint[](7);
		TokenPrice = getPricedata();

		uint Resultbeforebargaining = _tradeAmount.mul(TokenPrice[_tokenIN]).div(TokenPrice[_tokenOUT]);
		uint _bRate = bargainingRate.sub(citizenInfos[msg.sender].Friendliness);
		uint _bResult = Resultbeforebargaining.mul(_bRate).div(10000);
		uint ResultAfterbargaining = Resultbeforebargaining.sub(_bResult);
		uint _Tax = ResultAfterbargaining.mul(tradeTaxFee).div(10000);
		uint TraderResult = ResultAfterbargaining.sub(_Tax);
		
		require(IERC20(getTokenAddr(_tokenOUT)).transfer(msg.sender, TraderResult));
		emit swapETokensForTokens(_tradeAmount, TraderResult, _tokenIN, _tokenOUT);
    }

	//----------------Freeport query function----------------------------
	//--Check if the player is already familiar?--//
    function isFamiliar(address inputAddr) public view returns (bool) {
	    uint amountAddr = familiarList.length;
		bool _isFamiliar = false;
	
	    for (uint i = 0; i < amountAddr; i++) {
            if(familiarList[i] == inputAddr){
				_isFamiliar = true;
            }
        }
        return _isFamiliar;
    }
	
	//--Check input Player Info--//
    function checkAddressInfo(address inputAddr) public view returns(uint[] memory){
		require(isFamiliar(inputAddr), "Freeport : This this address is not in familiar list.");

		uint[] memory returnint = new uint[](4);
		returnint[0] = citizenInfos[inputAddr].IsReg;
		returnint[1] = citizenInfos[inputAddr].TalkTime;
		returnint[2] = citizenInfos[inputAddr].Friendliness;
		returnint[3] = citizenInfos[inputAddr].TradingAmount;

        return returnint;
    }
	
	//--Check Player Assets--//
    function checkAssets(address inputAddr) public view returns(uint[] memory){
		uint[] memory returnint = new uint[](5);
		returnint[0] = IERC20(_WoodAddr).balanceOf(inputAddr);
		returnint[1] = IERC20(_StoneAddr).balanceOf(inputAddr);
		returnint[2] = IERC20(_OreAddr).balanceOf(inputAddr);
		returnint[3] = IERC20(_WaterAddr).balanceOf(inputAddr);
		returnint[4] = IERC20(_FoodAddr).balanceOf(inputAddr);
		
        return returnint;
    }
	
	//--Check citizen's token price data--//
	function getPricedata() public view returns (uint[] memory) {
		uint amountsFPD = IERC20(_FPDAddr).balanceOf(address(this));

		uint priceMTC = amountsFPD.mul(1*10**uint(18)).div(IERC20(_MTCAddr).balanceOf(address(this)));
		uint priceWood = amountsFPD.mul(1*10**uint(18)).div(IERC20(_WoodAddr).balanceOf(address(this)));
		uint priceStone = amountsFPD.mul(1*10**uint(18)).div(IERC20(_StoneAddr).balanceOf(address(this)));
		uint priceOre = amountsFPD.mul(1*10**uint(18)).div(IERC20(_OreAddr).balanceOf(address(this)));
		uint priceWater = amountsFPD.mul(1*10**uint(18)).div(IERC20(_WaterAddr).balanceOf(address(this)));
		uint priceFood = amountsFPD.mul(1*10**uint(18)).div(IERC20(_FoodAddr).balanceOf(address(this)));

		uint[] memory returPricedata = new uint[](7);
		returPricedata[0] = priceMTC;
		returPricedata[1] = 1*10**uint(18);
		returPricedata[2] = priceWood;
		returPricedata[3] = priceStone;
		returPricedata[4] = priceOre;
		returPricedata[5] = priceWater;
		returPricedata[6] = priceFood;
        return returPricedata;
    }

	
	//--Get token in & token amounts out--//
    function getAmountsOut(uint8 _tokenIN, uint8 _tokenOUT, uint _tradeAmount) public view returns(
        uint _amountsOut){

		uint[] memory TokenPrice = new uint[](7);
		TokenPrice = getPricedata();
		
		uint Resultbeforebargaining = _tradeAmount.mul(TokenPrice[_tokenIN]).div(TokenPrice[_tokenOUT]);
		uint _bRate = bargainingRate.sub(citizenInfos[msg.sender].Friendliness);
		uint _bResult = Resultbeforebargaining.mul(_bRate).div(10000);
		uint ResultAfterbargaining = Resultbeforebargaining.sub(_bResult);
		uint _Tax = ResultAfterbargaining.mul(tradeTaxFee).div(10000);
		uint TraderResult = ResultAfterbargaining.sub(_Tax);
        return TraderResult;
    }
	
	//--Check talk recover time--//
    function inqTalkRecover(address inputAddr) public view returns(
        uint _RecoverTime){
		uint rLeftTime = now.sub(citizenInfos[inputAddr].TalkTime);
        return rLeftTime;
    }
	
    function _random(uint _block, uint bottom, uint top) private view returns(uint){
        bytes32 _hash = blockhash(_block);
        bytes memory seed = abi.encodePacked(rand(0, 1.15e77), _hash);
        return rand(seed, bottom, top);
    }

	//--Check Citizen address--//
	function setCitizenName(uint8 _Gender) public onlyWorldWill{
        (CitizenfirstName, CitizenlastName) = IFreeport(_FPName).GetRandomName(_Gender);
    }

	function setRandomCitizenName() private{
        uint RandomGender = _random(block.number, 0, 1);
        (CitizenfirstName, CitizenlastName) = IFreeport(_FPName).GetRandomName(uint8(RandomGender));
    }

    function checkCitizenfirstName() public view returns (string memory){
        return CitizenfirstName;
    }

    function checkCitizenlastName() public view returns (string memory){
        return CitizenlastName;
    }

	function getTokenAddr(uint8 _addIndex) public view returns (address) {
		address[] memory returTokenAddr = new address[](7);
		returTokenAddr[0] = _MTCAddr;
		returTokenAddr[1] = _FPDAddr;
		returTokenAddr[2] = _WoodAddr;
		returTokenAddr[3] = _StoneAddr;
		returTokenAddr[4] = _OreAddr;
		returTokenAddr[5] = _WaterAddr;
		returTokenAddr[6] = _FoodAddr;
        return returTokenAddr[_addIndex];
    }

	function DexAddr() public view returns(address){
        require(_dexAddr != address(0), "It's a null address");
        return _dexAddr;
    }
	
	function setDexAddr(address addr) public onlyWorldWill{
        _dexAddr = addr;
    }

	function Secretary() public view returns(address){
        require(_secretary != address(0), "It's a null address");
        return _secretary;
    }
	
	function setSecretary(address addr) public onlyWorldWill{
        _secretary = addr;
    }

	function MTCAddr() public view returns(address){
        require(_MTCAddr != address(0), "It's a null address");
        return _MTCAddr;
    }
	
	function setMTCAddr(address addr) public onlyWorldWill{
        _MTCAddr = addr;
    }

	function FPDAddr() public view returns(address){
        require(_FPDAddr != address(0), "It's a null address");
        return _FPDAddr;
    }
	
	function setFPDAddr(address addr) public onlyWorldWill{
        _FPDAddr = addr;
    }

    modifier onlySecretary{
        require(msg.sender == manager || msg.sender == Secretary(), "You are not Secretary.");
        _;
    }

    function SetupAll(address _sDEXAddr, address _sSecretaryAddr, address _sMTCAddr, address _sFPDAddr) public onlyWorldWill{
        setDexAddr(_sDEXAddr);
		setSecretary(_sSecretaryAddr);
		setMTCAddr(_sMTCAddr);
		setFPDAddr(_sFPDAddr);
    }
	
    function SetupRawMaterial(address _sWoodAddr, address _sStoneAddr, address _sOreAddr, address _sWaterAddr, address _sFoodAddr) public onlyWorldWill{
		_WoodAddr = _sWoodAddr;
		_StoneAddr = _sStoneAddr;
		_OreAddr = _sOreAddr;
		_WaterAddr = _sWaterAddr;
		_FoodAddr = _sFoodAddr;
    }
}

contract GaiaMetaverse {
    using Address for address;
    address public Gaia;
	
    constructor() public{
        Gaia = msg.sender;
    }
	
    event tokenCreatorResult(address indexed _XContract);

    modifier onlyGaia{
        require(msg.sender == Gaia, "Sender is not Gaia");
        _;
    }

    function changeGaia(address _new_Gaia) public onlyGaia {
        require(msg.sender == Gaia, "Sender is not Gaia");
        Gaia = _new_Gaia;
    }

    function GaiaCreateCitizen(
	)
       public
       onlyGaia
       returns (bool)
    {
        address _CitizenAddress = address(createAICitizen(msg.sender));
        emit tokenCreatorResult(_CitizenAddress);
        return true;
    }

    function createAICitizen(
	address _XGaia
	)
       private
       returns (AICitizenContract CitizenAddress)
    {
        return new AICitizenContract(_XGaia);
    }
}