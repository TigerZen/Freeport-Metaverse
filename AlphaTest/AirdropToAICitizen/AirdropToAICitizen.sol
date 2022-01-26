pragma solidity >= 0.5.17;

import "./math.sol";
import "./IERC20.sol";

contract Manager{
    address public superManager = 0xE34BdA906dDfa623a388bCa0BD343B764187f325;
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

    function withdrawfrom(uint amount) external onlyManager{
	    require(address(this).balance >= amount, "Insufficient balance");
        (msg.sender).transfer(amount);
    }

    function takeTokensToManager(address tokenAddr) external onlyManager{
        uint _thisTokenBalance = IERC20(tokenAddr).balanceOf(address(this));
        require(IERC20(tokenAddr).transfer(msg.sender, _thisTokenBalance));
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


contract cAirdropToAICitizen is Manager{
    using Address for address;

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

	function Secretary() public view returns(address){
        require(_secretary != address(0), "It's a null address");
        return _secretary;
    }
	
	function setSecretary(address addr) public onlyManager{
        _secretary = addr;
    }

	function MTCAddr() public view returns(address){
        require(_MTCAddr != address(0), "It's a null address");
        return _MTCAddr;
    }
	
	function setMTCAddr(address addr) public onlyManager{
        _MTCAddr = addr;
    }

	function FPDAddr() public view returns(address){
        require(_FPDAddr != address(0), "It's a null address");
        return _FPDAddr;
    }
	
	function setFPDAddr(address addr) public onlyManager{
        _FPDAddr = addr;
    }

    modifier onlySecretary{
        require(msg.sender == manager || msg.sender == Secretary(), "You are not Secretary.");
        _;
    }

    function SetupAll(address _sSecretaryAddr, address _sMTCAddr, address _sFPDAddr) public onlyManager{
		setSecretary(_sSecretaryAddr);
		setMTCAddr(_sMTCAddr);
		setFPDAddr(_sFPDAddr);
    }
	
    function SetupRawMaterial(address _sWoodAddr, address _sStoneAddr, address _sOreAddr, address _sWaterAddr, address _sFoodAddr) public onlyManager{
		_WoodAddr = _sWoodAddr;
		_StoneAddr = _sStoneAddr;
		_OreAddr = _sOreAddr;
		_WaterAddr = _sWaterAddr;
		_FoodAddr = _sFoodAddr;
    }
}

contract AirdropToAICitizen is cAirdropToAICitizen, math{
    using Address for address;
    function() external payable{}

	//----------------Freeport Function----------------------------
    function AirDropTAI(address _AIAddr) public onlySecretary{
	
		uint _AirDropMTC   = _random(block.number, 150000, 200000) * 10 ** uint(18);
		uint _AirDropFPD   = _random(block.number, 15000000, 20000000) * 10 ** uint(18);
		uint _AirDropWOOD  = _random(block.number, 3000000, 4000000) * 10 ** uint(18);
		uint _AirDropORE   = _random(block.number, 1500000, 2000000) * 10 ** uint(18);
		uint _AirDropSTONE = _random(block.number, 3000000, 4000000) * 10 ** uint(18);
		uint _AirDropWATER = _random(block.number, 15000000, 20000000) * 10 ** uint(18);
		uint _AirDropFOOD  = _random(block.number, 3500000, 5000000) * 10 ** uint(18);
	
		require(IERC20(MTCAddr()).transfer(_AIAddr, _AirDropMTC));
		require(IERC20(FPDAddr()).transfer(_AIAddr, _AirDropFPD));
		require(IERC20(_WoodAddr).transfer(_AIAddr, _AirDropWOOD));
		require(IERC20(_StoneAddr).transfer(_AIAddr, _AirDropORE));
		require(IERC20(_OreAddr).transfer(_AIAddr, _AirDropSTONE));
		require(IERC20(_WaterAddr).transfer(_AIAddr, _AirDropWATER));
		require(IERC20(_FoodAddr).transfer(_AIAddr, _AirDropFOOD));
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
	
    function _random(uint _block, uint bottom, uint top) private view returns(uint){
        bytes32 _hash = blockhash(_block);
        bytes memory seed = abi.encodePacked(rand(0, 1.15e77), _hash);
        return rand(seed, bottom, top);
    }
}