pragma solidity >= 0.5.17;

contract FPInitLandType {
    address public superManager = 0x052A8960909ACC21c22b83fDF6b1c60F254f9a3a;
    address public manager;
	
    uint8 initLandType1;
    uint8 initLandType2;
    uint8 initLandType3;
    uint8 initLandType4;
	
    constructor() public{
        manager = msg.sender;
		initLandType1 = 1;
		initLandType2 = 2;
		initLandType3 = 3;
		initLandType4 = 4;
    }

    modifier onlyManager{
        require(msg.sender == manager || msg.sender == superManager, "Not manager");
        _;
    }

    function changeManager(address _new_manager) public {
        require(msg.sender == superManager, "It's not superManager");
        manager = _new_manager;
    }

    function InitLandType(uint _AreaNO, uint _LandNO) public view returns(uint8 stype){
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
}