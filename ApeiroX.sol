/**
 *Submitted for verification at BscScan.com on 2021-06-03
*/

pragma solidity 0.5.16;


/*
 * ApeiroX Smart contract
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 * @dev get smart contract context
 */
 
 
contract Context {	
  // prevents deploying context as a stand alone smart contract
  constructor () internal { }
  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; 
    return msg.data;
  }
}



interface APEIROX20 {
  /**
   * @dev Total token supply
   */
  function totalSupply() external view returns (uint256);
  
  
  /**
   * @dev circulating token supply
   */
  function circulatingSupply() external view returns (uint256);
  
  
  /**
   * @dev released token supply
   */
  function releasedSupply() external view returns (uint256);
  
  
  /**
   * @dev reserved token supply
   */
  function reservedSupply() external view returns (uint256);
  

  /**
   * @dev token decimal value.
   */
  function decimals() external view returns (uint8);
  
  
  /**
   * @dev return incrementor value.
   */
  
  function getCurrentSupply() external returns (uint256) ;

  /**
   * @dev token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev token name.
  */
  function name() external view returns (string memory);


  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev get token balance on an account
   */
  function balanceOf(address account) external view returns (uint256);
    
  
  /**
   * @dev sendable tokens to another account
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  function approve(address spender, uint256 amount) external returns (bool);


  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
   
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}



/**
 * @dev Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
 
library SafeMath {
    
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
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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

contract Ownable is Context {
	
  address public _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }
  

  /**
   * @dev Returns the address of the current owner.
   */
   
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }

}

contract APEIROX is Context, APEIROX20 , Ownable {
	
	
  using SafeMath for uint256;

  mapping (address => uint256) public _balances;
  
  mapping(address => mapping(address => uint)) allowed;
  

  address public _contractOwner;
  address private _tokenRecipient;
  uint256 public _totalSupply;
  uint256 public _circulatingSupply;
  uint256 public _releasedSupply;
  uint256 private _amount ;
  uint256[] private _incrementor ;
  uint256 private  _yearCount ;
  uint256 private  _secondsCount;
  uint256 private  _launchDate ;
  uint256 private _currentDate ;
  uint256 private _allowableValue ;
  uint256 public _reserveSupply ;
  uint256 private _reserveUnit ;
  uint256 private _unlockTimestammp;
  uint8 public _decimals;
  string public _symbol;
  string public _name;
  
// modifier tokenSender() {
//     require(_contractOwner != _tokenRecipient , "caller cannot send coin to self");
//     _;
//   }

modifier spendableToken() {	
		  
    require( _balances[_contractOwner] - _amount >= _reserveSupply );
    _;
}
  
  // make _unlockTimestammp = 31536000 when you are launching to mainnet

  constructor() public {
	
	_contractOwner = msg.sender; 
    _name = "ApeiroX";
    _symbol = "APX";
    _decimals = 18 ;
	_incrementor = [2,4,6,7,8,9,10];
    _totalSupply  =   10000000000000000000000000000000;
	_reserveUnit =    1000000000000000000000000000000;
	_releasedSupply = 2000000000000000000000000000000;
	_reserveSupply =  8000000000000000000000000000000;
	_yearCount = 0 ;
	_launchDate = now ;
	_currentDate = now ;
	_unlockTimestammp = now ;	
    _balances[msg.sender] = _totalSupply;

    emit Transfer(address(0), msg.sender, _totalSupply);
  }
  

  /**
  * @dev Returns ApeiroX token name.
  */
  
  function name() external view returns (string memory) {
    return _name;
  }
  
    
  /**
   * @dev Returns ApeiroX token symbol.
   */
   
  function symbol() external view returns (string memory) {
    return _symbol;
  }
  
  /**
   * @dev Returns the ApeiroX token owner.
   */ 
   
  function getCurrentSupply() external returns (uint256) {	  
	  
	   //_currentDate = now.add(31536000) ;
	  
	 _currentDate = now ;
	 
	_secondsCount = _currentDate.sub(_launchDate , "Error !!! cannot subtract now date from lunch date")  ;
	
	_yearCount = _secondsCount.div(31536000) ;
	
	if(_yearCount > 6){
        _yearCount = 6;
    }
	
	_releasedSupply = _incrementor[_yearCount].mul(_reserveUnit) ;	
	
	_reserveSupply = _totalSupply.sub(_releasedSupply);
	  
    return _incrementor[_yearCount].mul(_reserveUnit) ;
  }
  
  

  /**
   * @dev Returns ApeiroX token decimals.
   */
   
  function decimals() external view returns (uint8) {
    return _decimals;
  }
  
  /**
   * @dev See {APEIROX20-totalSupply}.
   */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }
  
  
  /**
   * @dev See {APEIROX20-circulatingSupply}.
   */
  function circulatingSupply() external view returns (uint256){
  
     return _circulatingSupply ;
  
  }
  
  
  /**
   * @dev See {APEIROX20-releasedSupply}.
   */
  function releasedSupply() external view returns (uint256){
  
	return _releasedSupply ;
  
  }
  
  
  /**
   * @dev See {APEIROX20-reservedSupply}.
   */
  function reservedSupply() external view returns (uint256){
   
	return _reserveSupply ;
   
  }
   
  
  /**
   * @dev See {APEIROX20-balanceOf}.
   */
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account] ;
  }

  
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
  function approve(address spender, uint tokens) public returns (bool success) {
      allowed[msg.sender][spender] = tokens;
      emit Approval(msg.sender, spender, tokens);
      return true;
  }
  
  /**
   * @dev See {APEIROX-transfer. tokens are locked for one year only
   */
  function transfer(address recipient, uint256 amount) external returns (bool) {
	  
	  _amount = amount ;
	  
	  _tokenRecipient = recipient ;
	  
	  	  
    _transfer(_msgSender(), recipient, amount);
    return true;
	
  }

  /**
   * @dev send token from sender to recippient
   */
   
   
  function _transfer(address sender, address recipient, uint256 amount) spendableToken internal {
    require(sender != address(0), "APEIROX20: transfer from the zero address");
    require(recipient != address(0), "APEIROX20: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount, "APEIROX20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
	
	_circulatingSupply += amount ;
	
    emit Transfer(sender, recipient, amount);
  }

  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `amount`.
   */

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), allowed[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, allowed[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, allowed[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
    return true;
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
   function _approve(address sender, address spender, uint256 amount) internal {
    require(sender != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

    allowed[sender][spender] = amount;
    emit Approval(sender, spender, amount);
  }

   /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) spendableToken internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
   * from the caller's allowance.
   *
   * See {_burn} and {_approve}.
   */
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), allowed[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
  } 

}