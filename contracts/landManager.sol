// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function add32(uint32 a, uint32 b) internal pure returns (uint32) {
        uint32 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

interface IERC20 {
    function decimals() external view returns (uint8);
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard}
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target, 
        bytes memory data, 
        uint256 value, 
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _functionCallWithValue(
        address target, 
        bytes memory data, 
        uint256 weiValue, 
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

  /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target, 
        bytes memory data, 
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(
        address target, 
        bytes memory data, 
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success, 
        bytes memory returndata, 
        string memory errorMessage
    ) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    function addressToString(address _address) internal pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(_address));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _addr = new bytes(42);

        _addr[0] = '0';
        _addr[1] = 'x';

        for(uint256 i = 0; i < 20; i++) {
            _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }

        return string(_addr);

    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token, 
        address spender, 
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender)
            .sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IOwnable {
  function manager() external view returns (address);

  function renounceManagement() external;
  
  function pushManagement( address newOwner_ ) external;
  
  function pullManagement() external;
}


abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor ()  {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}



contract Ownable is IOwnable, ReentrancyGuard {

    address internal _owner;
    address internal _newOwner;

    event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
    event OwnershipPulled(address indexed previousOwner, address indexed newOwner);

    constructor () {
        _owner = msg.sender;
        emit OwnershipPushed( address(0), _owner );
    }

    function manager() public view override returns (address) {
        return _owner;
    }

    modifier onlyManager() {
        require( _owner == msg.sender, "Ownable: caller is not the owner" );
        _;
    }

    function renounceManagement() public virtual override onlyManager() {
        emit OwnershipPushed( _owner, address(0) );
        _owner = address(0);
    }

    function pushManagement( address newOwner_ ) public virtual override onlyManager() {
        require( newOwner_ != address(0), "Ownable: new owner is the zero address");
        emit OwnershipPushed( _owner, newOwner_ );
        _newOwner = newOwner_;
    }
    
    function pullManagement() public virtual override {
        require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
        emit OwnershipPulled( _owner, _newOwner );
        _owner = _newOwner;
    }
}



contract landManager is Ownable {
    using SafeMath for uint256;
    using SafeMath for uint32;
    using SafeERC20 for IERC20;

    struct Point {
        uint x;
        uint y; 
        address owner;
    } 

    
    struct Proposal {
        uint Id;
        uint xStart;
        uint xEnd;
        uint yStart;
        uint yEnd;
        uint proposalTime;
        uint status;
        uint voteOK;
        uint voteKO;
        address proposer;
    }

    struct ExtendProposal {
        uint Id;
        uint xEnd;
        uint yEnd;
        uint proposalTime;
        uint status;
        uint voteOK;
        uint voteKO;
        address proposer;
    }
    
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Voted {
        uint256 proposalId;
        bool choice;
    }

    uint public xLandLimit;

    uint public yLandLimit;

    uint public timeForVoting = 1 minutes;

    uint public lastProposalTime;

    uint public lastProposalExtendTime;

    uint public proposalId = 0;

    uint public proposalExtendId = 0;

    uint public currentProposalIdInVoting = 1;

    uint public currentExtensionProposalIdInVoting = 1;

    address public landDesigner;


    mapping(uint => Proposal) proposals;

    mapping(uint => ExtendProposal) extendproposals;

    address[] public proposalsList;

    address[] public proposalsExtendList;

    Voter[] internal voters; //tableau dynamique des votants

    mapping(address => mapping(uint256 =>bool)) voterId;  //pointeur pour identifier l'adresse d'un votant

    mapping(uint256=>mapping(uint256 => address)) ownerMap;


    constructor ( uint _xEnd, uint _yEnd) {
        xLandLimit = _xEnd;         // land limit in X
        yLandLimit = _yEnd;         // land limit in Y
        landDesigner = msg.sender;  // creator of the contract is the landDesigner
    }


    function setTimeForVoting(uint _timeForVoting) public  onlyManager {
        timeForVoting = _timeForVoting;
    }


    /**
        @notice this function assign a square to an address
        @param _x uint256 start of abscissa of the land
        @param _y uint256 end of ordinate of the land
     */
    function assignProperty(address _address, uint256 _x, uint256 _y) public  returns (bool) {

        require((_x <= xLandLimit), "the land is not so big in X");
        require((_y <= yLandLimit), "the land is not so big in Y");
        require((isThisSquareOwned(_x, _y) == false), "this land has already been bought");//verify is this land is owned

        ownerMap[_x][_y] = _address;

        return true;
    }


    /**
        @notice this function assign a land to an address : all squares contained in the perimeter of the variables
        @param _xStart uint256 start of abscissa of the land
        @param _xEnd uint256 end of abscissa of the land
        @param _yStart uint256 start of ordinate of the land
        @param _yEnd uint256 end of ordinate of the land
     */
    function assignLand(address _address, uint256 _xStart, uint256 _xEnd, uint256 _yStart, uint256 _yEnd) public  returns (bool assigned) {
        require(_xEnd >= _xStart, "xEnd should be superior or equal to xStart");
        require(_yStart <= _yEnd, "yEnd should be superior or equal to yStart");
        require((_xStart <= xLandLimit && _xEnd <= xLandLimit), "the land is not so big in X");
        require((_yStart <= yLandLimit && _yEnd <= yLandLimit), "the land is not so big in Y");

        for (uint _ix = _xStart; _ix <= _xEnd;) { 
            for (uint _iy = _yStart; _iy <= _yEnd;) {
                    assignProperty(_address, _ix, _iy);

                    _iy++;
            }
            _ix++;
        }
        return true;
    }


    /**
        @notice this function checks if some coordinates are owned
        @param _xStart uint256 start of abscissa of the land
        @param _xEnd uint256 end of abscissa of the land
        @param _yStart uint256 start of ordinate of the land
        @param _yEnd uint256 end of ordinate of the land
     */
    function isThisLandOwned(uint256 _xStart, uint256 _xEnd, uint256 _yStart, uint256 _yEnd) view public returns (bool isItOwned) {
        for (uint _ix = _xStart; _ix <= _xEnd;) { 
            for (uint _iy = _yStart; _iy <= _yEnd; ) { 
                address owned = ownerMap[_ix][_iy];
                if (owned != address(0)) {
                    return true;
                }
                _iy++;
            } 
            _ix++;
        }
        return false;
    }


    /**
        @notice this function returns the owner of a coordinate x,y
        @param _x uint256 start of abscissa of the square
        @param _y uint256 end of ordinate of the square
     */
    function readLand(uint256 _x, uint256 _y) view public returns (address){
        return (ownerMap[_x][_y]);
    }


    /**
        @notice this function checks if the square of the coordinates x,y is owned
        @param _x uint256 start of abscissa of the square
        @param _y uint256 end of ordinate of the square
     */
    function isThisSquareOwned(uint256 _x, uint256 _y) view public returns (bool isItOwned) {
        address owned = ownerMap[_x][_y];
            if (owned != address(0)) {
                    return true;
            }
    }


    /**
        @notice calls 2 function : buyingProposal & updateVote
        @param _address address the submitter of the proposal
        @param _xStart uint256 
        @param _xEnd uint256
        @param _yStart uint256
        @param _yEnd uint256
     */
    function buyingProposalAndUpdateVote (address _address, uint256 _xStart, uint256 _xEnd, uint256 _yStart, uint256 _yEnd) public {
        updateVote();//check if voting time for this proposal is passed
        buyingProposal(_address, _xStart,_xEnd, _yStart, _yEnd);
    }


    /**
        @notice this function register the buying land proposal, after checking some criteria
        @param _address address the submitter of the proposal
        @param _xStart uint256 start of abscissa of the land
        @param _xEnd uint256 end of abscissa of the land
        @param _yStart uint256 start of ordinate of the land
        @param _yEnd uint256 end of ordinate of the land
     */
    function buyingProposal  (address _address, uint256 _xStart, uint256 _xEnd, uint256 _yStart, uint256 _yEnd) internal {
        require(_xEnd >= _xStart, "xEnd should be superior or equal to xStart");
        require(_yStart <= _yEnd, "yEnd should be superior or equal to yStart");
        require((_xStart <= xLandLimit && _xEnd <= xLandLimit), "the land is not so big in X");
        require((_yStart <= yLandLimit && _yEnd <= yLandLimit), "the land is not so big in Y");
        require((isThisLandOwned(_xStart, _xEnd, _yStart, _yEnd) == false), "this land is already owned");
        
        lastProposalTime = block.timestamp;
        proposalId++; //count of proposals
        proposals[proposalId] = Proposal(proposalId,  _xStart, _xEnd, _yStart, _yEnd, block.timestamp, 1, 0, 0, _address);
        proposalsList.push(_address);   

    }


    /**
        @notice this function calls updateVote & voteForProposal
        @param _address address of the voter
        @param _proposalId uint256 start of abscissa of the land
        @param _choice bool vote true or false (OK or KO)
     */
     function voteForProposalAndUpdateVote (address _address, uint256 _proposalId, bool _choice) public {
        updateVote(); //check if voting time for this proposal is passed
        voteForProposal(_address, _proposalId, _choice);
     } 


    /**
        @notice this function takes into account the vote for the current proposal in voting
        @param _address address of the voter
        @param _proposalId uint256 start of abscissa of the land
        @param _choice bool vote true or false (OK or KO)
     */
     function voteForProposal (address _address, uint _proposalId, bool _choice) internal {

        require(_proposalId == currentProposalIdInVoting, "This is not the proposal currently in voting");              //check if proposalId is currently in voting 
        require(isOwner(_address) == true, "This address is not owner" );                                               //check if the addres is owner
        require(voterId[_address][_proposalId] == false, "This address has already voted for this proposal");           //check if address already voted
        require(lastProposalTime + timeForVoting > block.timestamp, "The time for voting on this proposal has passed"); // check if time already passed for this proposal

        if (_choice == true) {
            proposals[_proposalId].voteOK++;
        }
        else {
            proposals[_proposalId].voteKO++;
        }
        voterId[_address][_proposalId] = true;
     }


    /**
        @notice calls 2 function : extendProposal & updateVote
        @param _address address the submitter of the proposal
        @param _xEnd uint256
        @param _yEnd uint256
     */
    function proposalForExtendingMaplAndUpdateVote (address _address, uint256 _xEnd, uint256 _yEnd) public {
        updateVote();//check if voting time for this proposal is passed
        proposalForExtendingMap(_address, _xEnd, _yEnd);
    }


    /**
        @notice this function register the extension land proposal, after checking some criteria
        @param _address address the submitter of the proposal
        @param _xEnd uint256 end of abscissa of the land
        @param _yEnd uint256 end of ordinate of the land
     */
    function proposalForExtendingMap  (address _address, uint256 _xEnd, uint256 _yEnd) internal {
        require((_xEnd != xLandLimit) || (_yEnd != yLandLimit), "Please chose limits different from existing ones");
        require((_xEnd >= xLandLimit) && (_yEnd >= yLandLimit) , "xEnd or yEnd should be superior or equal to actual limitation");
        require(isOwner(_address) == true, "This address is not owner" );//check if the address is owner
        
        
        lastProposalExtendTime = block.timestamp;
        proposalExtendId++; //count of proposals
        extendproposals[proposalExtendId] = ExtendProposal(proposalExtendId,  _xEnd, _yEnd, block.timestamp, 1, 0, 0, _address);
        proposalsExtendList.push(_address);   

    }





     function voteForExtendProposalAndUpdateVote (address _address, uint _proposalExtendId, bool _choice) public {
        updateVote(); //check if voting time for this proposal is passed
        voteForExtendProposal(_address, _proposalExtendId, _choice);
     }


    /**
        @notice this function takes into account the vote for the current proposal in voting
        @param _address address of the voter
        @param _proposalExtendId uint256 start of abscissa of the land
        @param _choice bool vote true or false (OK or KO)
     */
     function voteForExtendProposal (address _address, uint _proposalExtendId, bool _choice) internal {

        require(_proposalExtendId == currentExtensionProposalIdInVoting, "This is not the proposal currently in voting");              //check if proposalId is currently in voting 
        require(isOwner(_address) == true, "This address is not owner" );                                               //check if the addres is owner
        require(voterId[_address][_proposalExtendId] == false, "This address has already voted for this proposal");           //check if address already voted
        require(lastProposalExtendTime + timeForVoting > block.timestamp, "The time for voting on this proposal has passed"); // check if time already passed for this proposal

        if (_choice == true) {
            extendproposals[_proposalExtendId].voteOK++;
        }
        else {
            extendproposals[_proposalExtendId].voteKO++;
        }
        voterId[_address][_proposalExtendId] = true;
     }



    /**
        @notice this function checks if an address is owner
        @param _address address to check
     */
    function isOwner(address _address) view public returns(bool) {
        for (uint _ix = 1; _ix <= xLandLimit;) { 
            for (uint _iy = 1; _iy <= yLandLimit;) {
                    if ((ownerMap[_ix][_iy] == _address)) {
                        return true;
                    }
                    _iy++;
            }
            _ix++;
        }
        return false;
    }


    /**
        @notice this function returns the vote of an address, for a proposalId
        @param _address address to check
        @param _proposalId the one to check
     */
    function getVote(address _address, uint256 _proposalId) view public returns(bool){
        return ( voterId[_address][_proposalId]);
    }


    /**
        @notice this function checks if the voting time is finished, if one proposal has some majority votes and opens the next proposal, if it exists
     */
    function updateVote() public {
        if (proposals[currentProposalIdInVoting].proposalTime + timeForVoting < block.timestamp) { 
            uint256 _votesOK = proposals[currentProposalIdInVoting].voteOK;
            uint256 _votesKO = proposals[currentProposalIdInVoting].voteKO;
            
            if  (_votesOK > _votesKO) {
                //and the winner is ...
                assignLand(proposals[currentProposalIdInVoting].proposer, proposals[currentProposalIdInVoting].xStart, proposals[currentProposalIdInVoting].xEnd, proposals[currentProposalIdInVoting].yStart, proposals[currentProposalIdInVoting].yEnd);
            }
            if (proposalId > currentProposalIdInVoting) {
                //if the next proposal Id submitted is superior to the current proposal Id :
                currentProposalIdInVoting++; //the next proposal is opened
            }
        }



        if (extendproposals[currentExtensionProposalIdInVoting].proposalTime + timeForVoting < block.timestamp) { 
            uint256 _votesOK = extendproposals[currentExtensionProposalIdInVoting].voteOK;
            uint256 _votesKO = extendproposals[currentExtensionProposalIdInVoting].voteKO;
            
            if  (_votesOK > _votesKO) {
                //and the winner is ...
                   xLandLimit = extendproposals[currentExtensionProposalIdInVoting].xEnd;
                   yLandLimit = extendproposals[currentExtensionProposalIdInVoting].yEnd;
                 }
            if (proposalExtendId > currentExtensionProposalIdInVoting) {
                //if the next proposal Id submitted is superior to the current proposal Id :
                currentExtensionProposalIdInVoting++; //the next proposal is opened
            }
        }
    }




    /**
        @notice this function returns the details of one proposal
        @param _id  id of proposal
     */
    function getProposal(uint256 _id) view public returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return ( proposals[_id].xStart, proposals[_id].xEnd, proposals[_id].yStart, proposals[_id].yEnd, proposals[_id].proposalTime, proposals[_id].voteOK , proposals[_id].voteKO);

    }

    /**
        @notice this function returns the details of one proposal
        @param _id  id of proposal
     */
    function getExtendProposal(uint256 _id) view public returns (uint256, uint256, uint256, uint256, uint256, address) {
        return ( extendproposals[_id].xEnd, extendproposals[_id].yEnd, extendproposals[_id].proposalTime, extendproposals[_id].voteOK , extendproposals[_id].voteKO, extendproposals[_id].proposer);

    }


    
}