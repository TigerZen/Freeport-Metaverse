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
    address public manager;

    constructor() public{
        manager = msg.sender;
    }

    modifier onlyManager{
        require(msg.sender == manager, "Is not manager");
        _;
    }

    function changeManager(address _new_manager) external onlyManager{
        require(msg.sender == manager, "You are not Manager");
        manager = _new_manager;
    }

    function withdraw() external onlyManager{
        (msg.sender).transfer(address(this).balance);
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

interface AirDrop{
    function GaiaMint(address _Addr, uint8 _typeID, uint8 _rarityID) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract AirDrop88888MTC is Manager, math{
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private _whitelist;
    address public FPANFT = 0xA297E00F923adFeB21F00E730f07042Eb40B95F7;
	address public _MTCAddr = 0x5F1D2cfDEB097B83eD2f35Cf3E827DE2b700F05a;
	
	address[] public participantList;
	uint[] public MTCGiveAmounts;

    function setAddr(address _FPANFTAddr, address _sMTCAddr) public onlyManager {
        FPANFT = _FPANFTAddr;
        _MTCAddr = _sMTCAddr;
    }
	
	function checkParticipantList(uint sort) public view returns(address){
        return participantList[sort];
    }

	function checkMTCGiveAmounts(uint sort) public view returns(uint256){
		return MTCGiveAmounts[sort];
	}

    function getParticipantListLength() public view returns (uint256) {
        return participantList.length;
    }

    function getMTCGiveAmountsLength() public view returns (uint256) {
        return MTCGiveAmounts.length;
    }

    function CheckAllParticipant() public view returns (address[] memory) {
        uint _balanceOf = getParticipantListLength();
		address[] memory AddrReturn = new address[](_balanceOf);
        for (uint i = 0; i < _balanceOf; i++){
		    AddrReturn[i] = participantList[i];
        }
        return AddrReturn;
    }

    function CheckAllMTCGiveAmounts() public view returns (uint[] memory) {
        uint _balanceOf = getMTCGiveAmountsLength();
		uint[] memory uintReturn = new uint[](_balanceOf);
        for (uint i = 0; i < _balanceOf; i++){
		    uintReturn[i] = MTCGiveAmounts[i];
        }
        return uintReturn;
    }
	
    function isparticipantList(address _youAddress) public view returns (bool) {
        uint _addressAmount = participantList.length;
		bool _IsParticipantList = false;
        for (uint i = 0; i < _addressAmount; i++){
			if(_youAddress == participantList[i]){
				_IsParticipantList = true;
			}
        }
        return _IsParticipantList;
    }
	
    function checkpantListIndex(address _youAddress) public view returns (uint256) {
        require(isparticipantList(_youAddress), "AirDropMTC : You are not the winner.");
        uint _addressAmount = getParticipantListLength();
		uint _pantListIndex = 0;
        for (uint i = 0; i < _addressAmount; i++){
			if(_youAddress == participantList[i]){
				_pantListIndex = i;
			}
        }
        return _pantListIndex;
    }

    //----------------Whitelist----------------------------
	
    function addWhitelist(address _addToken) internal returns(bool) {
        require(_addToken != address(0), "SwapMining: token is the zero address");
        return EnumerableSet.add(_whitelist, _addToken);
    }

    function delWhitelist(address _delToken) internal returns(bool) {
        require(_delToken != address(0), "SwapMining: token is the zero address");
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

    event lotteryResult(uint _Sort, uint _drawNO, address _winnerAddr);
    event AirDropNFTResult(uint _mareId, uint _stallionId, address _winnerAddr);

	//----------------Air Drop MTC----------------------------

	//--Add participant address Manager only--//
    function Addparticipant(address[] memory _ParticipantAddrs, uint[] memory _MTCGiveAmounts) public onlyManager returns (bool) {
        uint _addressAmount = _ParticipantAddrs.length;
        for (uint i = 0; i < _addressAmount; i++){
			if(!isWhitelist(_ParticipantAddrs[i])){
				participantList.push(_ParticipantAddrs[i]);
				MTCGiveAmounts.push(_MTCGiveAmounts[i]);
				addWhitelist(_ParticipantAddrs[i]);
			}else{
				MTCGiveAmounts[checkpantListIndex(_ParticipantAddrs[i])] += _MTCGiveAmounts[i];
			}
        }
        return true;
    }
	
    function AirDropMTCXTimes(uint _DropMin, uint _DropMax) public onlyManager{
        for (uint i = _DropMin; i < _DropMax; i++){
		    AirDropMTC(i);
			//AirDrop(FPANFT).GaiaMint(participantList[i], 5, 4);
        }
    }

    function AirDropMTC(uint _Sort) public onlyManager{
		require(AirDrop(_MTCAddr).transfer(participantList[_Sort], MTCGiveAmounts[_Sort]));
    }

	//--Manager only--//
	function destroy() external onlyManager{ 
        selfdestruct(msg.sender); 
	}
}