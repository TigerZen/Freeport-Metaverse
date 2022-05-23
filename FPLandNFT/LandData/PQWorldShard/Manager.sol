contract Manager{

    address public superManager = 0xe640428315E8929204ED723914728Ae8d623C429;
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

}