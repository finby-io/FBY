pragma solidity 0.5.16;

interface ISOL20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Context {
    constructor() {}

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        require(_owner == msg.sender, "security guaranteed administrator only");
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(_owner == msg.sender, "security guaranteed administrator only");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(_owner == msg.sender, "security guaranteed administrator only");
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/* Token in same structure as ERC20  */
contract FinbyToken is Context, ISOL20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;
    uint256 public _firstDayDate;
    uint256 public _taxValue;

    /* fee */
    address public _walletTax; /* 1.0% */

    /* Initial Holders */
    address public _privateEarning; /*6.0% - locked for 4 months*/
    address public _teamEarning; /*15% - locked for 6 months*/
    address public _foundersEarning; /*15% - locked for 12 months*/
    address public _salesEarning; /*11% */
    address public _communityEarning; /*20% */
    address public _foundation; /*13% */
    address public _ecosystem; /*12% */
    address public _liquity; /*7% */

    /* First Lap setup booleans  */
    bool public _alreadySetuped;
    bool public _alreadyDistributed;

    constructor() {
        _name = "FINBY COIN";
        _symbol = "FBY";
        _decimals = 18;
        _totalSupply = 1000000000 * (10**18);
        _balances[msg.sender] = 1000000000 * (10**18);
        _alreadyDistributed = false;
        _alreadySetuped = false;
        _firstDayDate = block.timestamp;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function initialDistribution(
        address payable privateEarning,
        address payable teamEarning,
        address payable foundersEarning,
        address payable salesEarning,
        address payable communityEarning,
        address payable foundation,
        address payable ecosystem,
        address payable liquity
    ) public onlyOwner {
        require(_owner == msg.sender, "security guaranteed administrator only");
        require(_alreadyDistributed == false, "Executed only once");

        _privateEarning = privateEarning; /*6.0% - locked for 4 months*/
        _teamEarning = teamEarning; /*15% - locked for 6 months*/
        _foundersEarning = foundersEarning; /*15% - locked for 12 months*/
        _salesEarning = salesEarning; /*11% */
        _communityEarning = communityEarning; /*20% */
        _foundation = foundation; /*13% */
        _ecosystem = ecosystem; /*12% */
        _liquity = liquity; /*7% */

        _balances[_privateEarning] = 60000000 * (10**18);
        _balances[_teamEarning] = 150000000 * (10**18);
        _balances[_foundersEarning] = 150000000 * (10**18);
        _balances[_salesEarning] = 110000000 * (10**18);
        _balances[_communityEarning] = 200000000 * (10**18);
        _balances[_foundation] = 130000000 * (10**18);
        _balances[_ecosystem] = 120000000 * (10**18);
        _balances[_liquity] = 70000000 * (10**18);

        emit Transfer(address(0), _privateEarning, 60000000 * (10**18));
        emit Transfer(address(0), _teamEarning, 150000000 * (10**18));
        emit Transfer(address(0), _foundersEarning, 150000000 * (10**18));
        emit Transfer(address(0), _salesEarning, 110000000 * (10**18));
        emit Transfer(address(0), _communityEarning, 200000000 * (10**18));
        emit Transfer(address(0), _foundation, 130000000 * (10**18));
        emit Transfer(address(0), _ecosystem, 120000000 * (10**18));
        emit Transfer(address(0), _liquity, 70000000 * (10**18));
        _alreadyDistributed = true;
    }

    /* OWNER */
    function initialSetup(address payable walletTax) public onlyOwner {
        require(_owner == msg.sender, "security guaranteed administrator only");
        require(_alreadySetuped == false, "Executed only once");
        _walletTax = walletTax; /*2.0% */
        _alreadySetuped = true;
    }

    function changeTax(uint256 amount) public onlyOwner {
        require(_owner == msg.sender, "security guaranteed administrator only");
        _taxValue = amount;
    }

    function totalBalanceContract() public view returns (uint256) {
        return address(this).balance;
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "SOL: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "SOL: decreased allowance below zero"
            )
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "SOL: transfer from the zero address");
        require(recipient != address(0), "SOL: transfer to the zero address");

        if (sender == _privateEarning) {
            require(
                block.timestamp >= _firstDayDate + 120 days,
                "Private investidors blocked for 4 months..."
            );
        }
        if (sender == _teamEarning) {
            require(
                block.timestamp >= _firstDayDate + 180 days,
                "Team blocked for 6 months..."
            );
        }
        if (sender == _foundersEarning) {
            require(
                block.timestamp >= _firstDayDate + 365 days,
                "Founders blocked for 12 months..."
            );
        }

        require(
            _balances[sender] >= amount,
            "SOL: transfer amount exceeds balance"
        );

        /*tax 6%*/
        uint256 taxFee;
        taxFee = amount;
        taxFee = taxFee.mul(_taxValue);
        taxFee = taxFee.div(100);

        _balances[sender] = _balances[sender].sub(
            amount,
            "SOL: transfer amount exceeds balance"
        );

        amount = amount.sub(taxFee);

        _balances[recipient] = _balances[recipient].add(amount);
        _balances[_walletTax] = _balances[_walletTax].add(taxFee);

        emit Transfer(sender, recipient, amount);
        emit Transfer(sender, _walletTax, taxFee);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "SOL: approve from the zero address");
        require(spender != address(0), "SOL: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
