pragma solidity >= 0.5.17;

import "./math.sol";
import "./IERC20.sol";

contract Manager{
    address public worldWill = 0xE34BdA906dDfa623a388bCa0BD343B764187f325;
    address public manager;

    constructor() public{
        manager = msg.sender;
    }

    modifier onlyWorldWill{
        require(msg.sender == manager || msg.sender == worldWill, "Is not manager");
        _;
    }

    function changeManager(address _new_manager) public {
        require(msg.sender == worldWill, "Is not worldWill");
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

library EnumerableSet {

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {// Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1;
            // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    struct Bytes32Set {
        Set _inner;
    }

    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

interface ISwap{
    function getOracle() external view returns (uint[] memory);
}

contract cAICitizenContract is Manager{
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private _whitelist;

    address _dexAddr = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;     //PancakeRouter address.
	address _secretary = 0x3C7Ba96F1F62081Fcb7AF0bFF4583d198ed660d6;   //Secretary address.
    address _MTCAddr = 0x4603b8d2e98B8Fbafe8A0CDe4F4381bBAB345c8b;     //MTC token contract address.
    address _FPDAddr = 0xa42bDcdfb8c717a9E8b58131640F2661Bf81620E;     //FPD token contract address.

    address _WoodAddr = 0x1Cb9DB4b6da87712695b1920060e0fC233F77175;    //Wood token contract address.
    address _StoneAddr = 0x397188b11eFCc14Fc579992d0983000D2B54e439;   //Stone token contract address.
    address _OreAddr = 0x8cBcd4e136563C38Ec534878D9C201421D43BaF0;     //Ore token contract address.
    address _WaterAddr = 0x6Eea93D4B0e6D9580e44Ef16b2C805F313852Dd2;   //Water token contract address.
    address _FoodAddr = 0x4efDE112638d8fC6cE9CE57Bd8a908cC02b5460D;    //Food token contract address.
	
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

	function regCitizens() public view returns(uint256){
        return EnumerableSet.length(_whitelist);
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
	
    //----------------Whitelist address----------------------------
    function addWhitelistBatch(address[] memory _wAddrs) public onlySecretary returns (bool) {
        uint _addressAmount = _wAddrs.length;
        for (uint i = 0; i < _addressAmount; i++){
			addWhitelist(_wAddrs[i]);
        }
        return true;
    }

    function addWhitelistManager(address _addToken) external onlySecretary {
        require(_addToken != address(0), "Freeport: token is the zero address");
            addWhitelist(_addToken);
    }

    function addWhitelist(address _addToken) internal returns(bool) {
        require(_addToken != address(0), "Freeport: token is the zero address");
        return EnumerableSet.add(_whitelist, _addToken);
    }

    function delWhitelist(address _delToken) internal returns(bool) {
        require(_delToken != address(0), "Freeport: token is the zero address");
        return EnumerableSet.remove(_whitelist, _delToken);
    }

    function getWhitelistLength() public view returns (uint256) {
        return EnumerableSet.length(_whitelist);
    }

    function isWhitelist(address _token) public view returns (bool) {
        return EnumerableSet.contains(_whitelist, _token);
    }

    function getWhitelist(uint256 _index) public view returns (address){
        require(_index <= getWhitelistLength() - 1, "index out of bounds");
        return EnumerableSet.at(_whitelist, _index);
    }
}

contract AICitizenContract is cAICitizenContract, math{
    using Address for address;
    function() external payable{}
	
	uint public bargainingRate = 2000; // 20% Bargaining Rate
	uint public tradeTaxFee = 500;     // 5% Tax

    address[] familiarList;

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
	
	//----------------Freeport Function----------------------------
    function setFee(uint amountRate, uint amountTax) public onlyWorldWill{
        bargainingRate = amountRate;
		tradeTaxFee = amountTax;
    }
	
	//--Set to AI citizen's familiar list--//
    function setFamiliar(address Useradder) internal {
		require(citizenInfos[Useradder].IsReg == 0, "Freeport : This address has been registered.");
		require(!isWhitelist(Useradder), "Freeport : This address is in list.");
		
		citizenInfos[Useradder].IsReg = 1;
		citizenInfos[Useradder].TalkTime = now.sub(86400);
		citizenInfos[Useradder].Friendliness = 1000;
		citizenInfos[Useradder].TradingAmount = 0;

		addWhitelist(Useradder);
		familiarList.push(Useradder);
		emit setFamiliarResult(Useradder, true);
    }
	
	//--Citizen Talk in Freeport--//
    function CitizenTalk() external {
		address Useradder = msg.sender;
		if(!isWhitelist(Useradder)){
			setFamiliar(Useradder);
		}
		require(inqAPRecover(Useradder) >= 86400, "Freeport : The TalkTime recovery period is not over yet.");
		
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
}