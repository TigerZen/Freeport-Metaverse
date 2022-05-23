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

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

library WorldShard {

    struct Shard{
        ShardData shardData;
        Resources resources;
        Building building;
        Initial initial;
    }

    struct Initial{
        bool shardData;
        bool resources;
        bool building;
    }

    struct ShardData{
        uint8 size;            //1-10
        uint8 surface;         //0-10
        bool isOpen;
        uint entranceFee;      //0-10,000
        uint resourcesP;       //1000-1,000,000
		uint salePrice;        //1-1,000,000
    }

    struct Resources{
        uint8 plantProducts;   //0-100
        uint8 oreProducts;     //0-100
        uint8 gemProducts;     //0-100
        uint8 water;           //0-100
        uint8 bioQuantity;     //0-100
    }

    struct Building{
        uint8 B1;              //0-100
        uint8 B2;              //0-100
        uint8 B3;              //0-100
        uint8 B4;              //0-100
        uint8 B5;              //0-100
    }

/////////////////////////////////_set////////////////////////////////////

    function set_shardData(Shard storage s, ShardData memory shardData) internal{

        if(!s.initial.shardData){
            s.initial.shardData = true;
        }
        s.shardData = shardData;
    }

    function set_resources(Shard storage s, Resources memory resources) internal{

        if(!s.initial.resources){
            s.initial.resources = true;
        }
        s.resources = resources;
    }

    function set_building(Shard storage s, Building memory building) internal{

        if(!s.initial.building){
            s.initial.building = true;
        }
        s.building = building;
    }
}

/*====================================================================================
                           PokeQ World Shard Contract
====================================================================================*/

contract PQWorldShard is Manager, ERC721{
    using SafeMath for uint256;
    using SafeMath for uint;
	
    using WorldShard for WorldShard.Shard;
    using WorldShard for WorldShard.ShardData;
    using WorldShard for WorldShard.Resources;
    using WorldShard for WorldShard.Building;

    mapping (uint => WorldShard.Shard) shards;
    using Address for address;
    uint createId;
    uint initAmount = 10000;
    uint256 public _totalSupply;
	
	uint _PayShard01 = 100*10**18;   // = 100 ether
    uint _PayShard02 = 20*10**18;    // = 20 ether
    uint _PayShard03 = 10*10**18;    // = 10 ether
    uint _PayShard04 = 5*10**18;     // = 5 ether
    uint _PayShard05 = 1*10**18;     // = 1 ether
    uint _ShardGift = 500;           // = 500 PKQT
	
    address _QToken;
    address _QPoolAddr;
    address _pokeQGame;
    address _QShop;
    address _race;
    
    constructor() public {
        _owner = msg.sender;
        createId = initAmount.add(1);
		_totalSupply = initAmount;
        _ownedTokensCount[address(this)].setBalance(_totalSupply);
    }
	
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    modifier onlyShardOwner(uint ShardId){
        require(ownerOf(ShardId) == msg.sender, "You are not owner of the Shard");
        _;
    }

    function setRace(address _address) public onlyManager{
        _race = _address;
    }

    function race() public view returns(address){
        require(_race != address(0), "Race contract address is null");
        return _race;
    }

    function setpokeQGame(address _address) public onlyManager{
        _pokeQGame = _address;
    }

    function pokeQGame() public view returns(address){
        require(_pokeQGame != address(0), "PokeQ game contract address is null");
        return _pokeQGame;
    }

    function setQShop(address _address) public onlyManager{
        _QShop = _address;
    }

    function qShop() public view returns(address){
        require(_QShop != address(0), "PokeQ shop contract address is null");
        return _QShop;
    }

    function QTokenAddr() public view returns(address){
        require(_QToken != address(0), "PKQT contract address is null");
        return _QToken;
    }

    function setQToken(address _address) public onlyManager{
        _QToken = _address;
    }

    modifier onlyPokeQGame{
        require(msg.sender == manager || msg.sender == pokeQGame() || msg.sender == race() ||  msg.sender == qShop(), "You are not game contract or manager.");
        _;
    }

    function linearTransfrom(uint oringinMax, uint nowMax, uint number) private pure returns(uint){
        return number.mul(nowMax).div(oringinMax);
    }
	
    function setShardPrice(uint8 Etype, uint amount) public onlyManager{
        require(Etype <= 6 && Etype >= 1, "Set Shard price type incorrect.");
		if(Etype == 1){
            _PayShard01 = amount;
        }else if(Etype == 2){
            _PayShard02 = amount;
        }else if(Etype == 3){
            _PayShard03 = amount;
        }else if(Etype == 4){
            _PayShard04 = amount;
        }else if(Etype == 5){
            _PayShard05 = amount;
        }else{
            _ShardGift = amount;
		}
    }
	
    event createShardResult(uint _ShardId, uint8 _size, uint8 _surface, uint _resources, uint8 _plantProducts, uint8 _oreProducts, uint8 _gemProducts, uint8 _water, uint8 _bioQuantity);

////////////////////////////////_init////////////////////////////////////

    function _initShardData(uint ShardId) private pure returns(WorldShard.ShardData memory){
        return WorldShard.ShardData(
            toUint8(rand(abi.encodePacked(ShardId, "size"), 1, 5)),                         //size
            toUint8(rand(abi.encodePacked(ShardId, "surface"), 1, 10)),                     //surface
            rand(abi.encodePacked(ShardId, "isOpen"), 1, 9) > 0 ,                           //isOpen
            toUint16(rand(abi.encodePacked(ShardId, "entranceFee"), 10, 100)),              //entranceFee
            toUint32(rand(abi.encodePacked(ShardId, "resourcesP"), 2100000000, 4200000000)),//resourcesP
			0
            );
    }

    function _initResources(uint ShardId) private pure returns(WorldShard.Resources memory){
        return WorldShard.Resources(
            toUint8(rand(abi.encodePacked(ShardId, "plantProducts"), 1, 30)),               //plantProducts
            toUint8(rand(abi.encodePacked(ShardId, "oreProducts"), 1, 30)),                 //oreProducts
            toUint8(rand(abi.encodePacked(ShardId, "gemProducts"), 1, 30)),                 //gemProducts
            toUint8(rand(abi.encodePacked(ShardId, "water"), 5, 30)),                       //water
            toUint8(rand(abi.encodePacked(ShardId, "bioQuantity"), 30, 50))                 //bioQuantity
            );
    }

    function _initBuilding(uint ShardId) private pure returns(WorldShard.Building memory){
        return WorldShard.Building(
            toUint8(rand(abi.encodePacked(ShardId, "B1"), 0, 20)),                          //B1
            toUint8(rand(abi.encodePacked(ShardId, "B2"), 0, 20)),                          //B2
            toUint8(rand(abi.encodePacked(ShardId, "B3"), 0, 20)),                          //B3
            toUint8(rand(abi.encodePacked(ShardId, "B4"), 0, 20)),                          //B4
            toUint8(rand(abi.encodePacked(ShardId, "B5"), 0, 20))                           //B5
            );
    }
    
////////////////////////////////inquire//////////////////////////////////
    
    function shardShardData(uint ShardId) private view returns(WorldShard.ShardData memory){
        if(!shards[ShardId].initial.shardData && ShardId <= initAmount){
            return _initShardData(ShardId);
        }else{
            return shards[ShardId].shardData;
        }
    }

    function shardResources(uint ShardId) private view returns(WorldShard.Resources memory){
        if(!shards[ShardId].initial.resources && ShardId <= initAmount){
            return _initResources(ShardId);
        }else{
            return shards[ShardId].resources;
        }
    }

    function shardBuilding(uint ShardId) private view returns(WorldShard.Building memory){
        if(!shards[ShardId].initial.building && ShardId <= initAmount){
            return _initBuilding(ShardId);
        }else{
            return shards[ShardId].building;
        }
    }

    ////////////////////external inquire/////////////////////

    function inqShardData(uint ShardId) external view returns
    (uint8 size, uint8 surface, bool isOpen, uint entranceFee, uint resourcesP, uint salePrice){
        WorldShard.ShardData memory sd = shardShardData(ShardId);
        return (sd.size, sd.surface, sd.isOpen, sd.entranceFee, sd.resourcesP, sd.salePrice);
    }

    function inqResources(uint ShardId) external view returns
    (uint8 plantProducts, uint8 oreProducts, uint8 gemProducts, uint8 water, uint8 bioQuantity){
        WorldShard.Resources memory r = shardResources(ShardId);
        return(r.plantProducts, r.oreProducts, r.gemProducts, r.water, r.bioQuantity);
    }

    function inqBuilding(uint ShardId) external view returns
    (uint8 B1, uint8 B2, uint8 B3, uint8 B4, uint8 B5){
        WorldShard.Building memory b = shardBuilding(ShardId);
        return(b.B1, b.B2, b.B3, b.B4, b.B5);
    }

    function exist(uint ShardId) public view returns(bool){
        return ownerOf(ShardId) != address(0);
    }

    function inqShardPrice(uint8 Etype) public view returns(uint ShardPrice){ 
        require(Etype <= 5 && Etype >= 1, "Check Shard price type incorrect.");
		if(Etype == 1){
            return _PayShard01;
        }else if(Etype == 2){
            return _PayShard02;
        }else if(Etype == 3){
            return _PayShard03;
        }else if(Etype == 4){
            return _PayShard04;
        }else{
            return _PayShard05;
        }
    }

////////////////////////////only PokeQ Game////////////////////////////////////

    function shardResult(uint ShardId, uint8 typ, bool win) public onlyPokeQGame{
        WorldShard.ShardData memory sd = shardShardData(ShardId);
        sd.resourcesP = toUint8(uint(sd.resourcesP).sub(1));
        shards[ShardId].set_shardData(sd);
    }
	
// ///////////////////////////other function///////////////////////////////

    function createShard(uint8 level) external onlyPokeQGame{
        _createShard(level);
    }
    
    function generateShard(uint8 level, address _player) external onlyPokeQGame{
        _createShard(level);
		_transferFrom(msg.sender, _player, createId.sub(1));
    }

    function generateShardBOX(uint8 level, address _player) private{
        _createShard(level);
		_transferFrom(msg.sender, _player, createId.sub(1));
    }

    function _generateShard(WorldShard.ShardData memory shardData, WorldShard.Resources memory resources,
        WorldShard.Building memory building) private{

        _mint(msg.sender, createId);

        shards[createId].shardData = shardData;
        shards[createId].resources = resources;
        shards[createId].building = building;
		emit createShardResult(createId, shardData.size, shardData.surface, shardData.resourcesP, resources.plantProducts, resources.oreProducts, resources.gemProducts, resources.water, resources.bioQuantity);
        createId = createId.add(1);
		_totalSupply = _totalSupply.add(1);
    }

    function _createShard(uint8 level) private{
		uint resX = uint(10000).mul(5**(level - 1));

        WorldShard.ShardData memory sd = WorldShard.ShardData(
            toUint8(rand(level+1, level+5)),      //size
            toUint8(rand(1, 10)),                           //surface
            false,                                          //isOpen
            0,                                              //entranceFee
            toUint32(rand(resX.div(2), resX)),              //resources
			0                                               //salePrice
            );

        WorldShard.Resources memory r = WorldShard.Resources(
            toUint8(rand((level-1)*10, level*10+50)), //plantProducts
            toUint8(rand((level-1)*10, level*10+50)), //oreProducts
            toUint8(rand((level-1)*10, level*10+50)), //gemProducts
            toUint8(rand((level-1)*10, level*10+50)), //water
            toUint8(rand((level-1)*10, level*10+50))  //bioQuantity
            );

        WorldShard.Building memory b = WorldShard.Building(0, 0, 0, 0, 0);

        _generateShard(sd, r, b);
    }
	
    function buyShardBOX() public payable{
		address PlayerA = msg.sender;
		
        if(msg.value == _PayShard01)
		{
			generateShardBOX(1, PlayerA);
			manager.toPayable().transfer(msg.value);
			require(IERC20(QTokenAddr()).transfer(msg.sender, _PayShard01.mul(_ShardGift)));
		}else if(msg.value == _PayShard02)
		{
			generateShardBOX(2, PlayerA);
			manager.toPayable().transfer(msg.value);
			require(IERC20(QTokenAddr()).transfer(msg.sender, _PayShard02.mul(_ShardGift)));
		}else if(msg.value == _PayShard03)
		{
			generateShardBOX(3, PlayerA);
			manager.toPayable().transfer(msg.value);
			require(IERC20(QTokenAddr()).transfer(msg.sender, _PayShard03.mul(_ShardGift)));
		}else if(msg.value == _PayShard04)
		{
			generateShardBOX(4, PlayerA);
			manager.toPayable().transfer(msg.value);
			require(IERC20(QTokenAddr()).transfer(msg.sender, _PayShard04.mul(_ShardGift)));
		}else if(msg.value == _PayShard05)
		{
			generateShardBOX(5, PlayerA);
			manager.toPayable().transfer(msg.value);
			require(IERC20(QTokenAddr()).transfer(msg.sender, _PayShard05.mul(_ShardGift)));
		}else{
			PlayerA.toPayable().transfer(msg.value);
		}
    }

    function buyShard(uint ShardId) public payable{
	    require(ShardId != 0, "You can't buy this Shard");
		
        address payable to = address(uint160(ownerOf(ShardId)));
        WorldShard.ShardData memory sd = shardShardData(ShardId);
		
        require(sd.salePrice > 0, "This Shard is not for sale");
        uint price = sd.salePrice*(0.01 ether);
        require(msg.value == price, "Value is not match");

        sd.salePrice = 0;
        if(to != address(this)){
            _transferFrom(to, msg.sender, ShardId);
            to.transfer(price);
        }else{
            _transferFrom(address(this), msg.sender, ShardId);
            manager.toPayable().transfer(price);
		}
		
        shards[ShardId].set_shardData(sd);
    }

    function PokeQSetS(uint ShardId, uint8 AType, uint8 Amount) external onlyPokeQGame{
        WorldShard.ShardData memory sd = shardShardData(ShardId);

        if(AType == 1) {
		    require(Amount <= 10 && Amount > 0, "Size error!");
			sd.size = Amount;
        }else if(AType == 2){
		    require(Amount <= 10 && Amount > 0, "Surface error!");
		    sd.surface = Amount;
        }else if(AType == 3){
		    require(Amount <= 10 && Amount > 0, "IsOpen error!");
		    sd.isOpen = Amount > 5;
        }else if(AType == 4){
		    require(Amount < 10000 && Amount >= 0, "EntranceFee error!");
		    sd.entranceFee = Amount;
        }else if(AType == 5){
		    require(Amount <= 6250000 && Amount > 0, "Resources error!");
		    sd.resourcesP = Amount;
        }else if(AType == 6){
		    require(Amount >= 0, "SalePrice error!");
		    sd.salePrice = Amount;
        }else{
		    revert("rand error");
        }
		shards[ShardId].set_shardData(sd);
    }

    function PokeQSetR(uint ShardId, uint8 AType, uint8 Amount) external onlyPokeQGame{
        WorldShard.Resources memory r = shardResources(ShardId);

        if(AType == 1) {
		    require(Amount <= 100 && Amount >= 0, "PlantProducts error!");
			r.plantProducts = Amount;
        }else if(AType == 2){
		    require(Amount <= 100 && Amount >= 0, "OreProducts error!");
			r.oreProducts = Amount;
        }else if(AType == 3){
		    require(Amount <= 100 && Amount >= 0, "GemProducts error!");
			r.gemProducts = Amount;
        }else if(AType == 4){
		    require(Amount <= 100 && Amount >= 0, "Water error!");
			r.water = Amount;
        }else if(AType == 5){
		    require(Amount <= 100 && Amount >= 0, "BioQuantity error!");
			r.bioQuantity = Amount;
        }else{
		    revert("rand error");
        }
		shards[ShardId].set_resources(r);
    }
 
    function PokeQSetB(uint ShardId, uint8 AType, uint8 Amount) external onlyPokeQGame{
        WorldShard.Building memory b = shardBuilding(ShardId);

        if(AType == 1) {
		    require(Amount <= 100 && Amount >= 0, "B1 error!");
			b.B1 = Amount;
        }else if(AType == 2){
		    require(Amount <= 100 && Amount >= 0, "B2 error!");
			b.B2 = Amount;
        }else if(AType == 3){
		    require(Amount <= 100 && Amount >= 0, "B3 error!");
			b.B3 = Amount;
        }else if(AType == 4){
		    require(Amount <= 100 && Amount >= 0, "B4 error!");
			b.B4 = Amount;
        }else if(AType == 5){
		    require(Amount <= 100 && Amount >= 0, "B5 error!");
			b.B5 = Amount;
        }else{
		    revert("rand error");
        }
		shards[ShardId].set_building(b);
    }

	function setRInOneTime(uint ShardId, uint8 _plantA, uint8 _oreA, uint8 _gemA, uint8 _waterA, uint8 _bioA) external onlyPokeQGame{
        WorldShard.Resources memory r = shardResources(ShardId);
		r.plantProducts = _plantA;
		r.oreProducts = _oreA;
		r.gemProducts = _gemA;
		r.water = _waterA;
		r.bioQuantity = _bioA;
		shards[ShardId].set_resources(r);
    }

	function takeTokensToManager(address tokenAddr) external onlyManager{
        uint _thisTokenBalance = IERC20(tokenAddr).balanceOf(address(this));
        require(IERC20(tokenAddr).transfer(msg.sender, _thisTokenBalance));
    }
}