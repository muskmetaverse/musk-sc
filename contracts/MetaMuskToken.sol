// SPDX-License-Identifier: MIT

pragma solidity 0.5.16;

import "./interfaces/IBEP20.sol";
import "./utils/Context.sol";
import "./utils/Ownable.sol";
import "./libs/SafeMath.sol";

contract MetaMuskToken is Context, IBEP20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;

    uint256 public startTimeICO;
    uint256 public endTimeICO;
    uint256 public totalAmountPerBNB;
    uint256 public percentClaimPerDate;
    mapping(address => UserInfo) public users;
    struct UserInfo {
        uint256 amountICO;
        uint256 amountClaimPerSec;
        uint256 claimAt;
        bool isSetup;
    }

    constructor(
        uint256 _startTimeICO,
        uint256 _endTimeICO,
        uint256 _totalAmountPerBNB,
        uint256 _percentClaimPerDate
    ) public {
        _name = "METAMUSK";
        _symbol = "METAMUSK";
        _decimals = 18;
        _totalSupply = 1000000000000000 * 10**18;
        _balances[msg.sender] = _totalSupply;

        startTimeICO = _startTimeICO;
        endTimeICO = _endTimeICO;
        totalAmountPerBNB = _totalAmountPerBNB;
        percentClaimPerDate = _percentClaimPerDate;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == this.getOwner(), "You are not owner.");
        _;
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address) {
        return owner();
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev See {BEP20-totalSupply}.
     */
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function buyICO() external payable {
        require(msg.value > 0, "value must be greater than 0");
        require(block.timestamp >= startTimeICO, "ICO time dose not start now");
        require(block.timestamp <= endTimeICO, "ICO time is expired");

        uint256 buyAmountToken = msg.value * totalAmountPerBNB;
        uint256 remainAmountToken = this.balanceOf(address(this));
        require(
            buyAmountToken <= remainAmountToken,
            "The contract does not enough amount token to buy"
        );

        if (users[msg.sender].isSetup == false) {
            UserInfo storage userInfo = users[msg.sender];
            userInfo.amountICO = buyAmountToken;
            userInfo.amountClaimPerSec = _calTotalAmountPerSec(buyAmountToken);
            userInfo.isSetup = true;
        } else {
            users[msg.sender].amountICO += buyAmountToken;
            users[msg.sender].amountClaimPerSec = _calTotalAmountPerSec(
                users[msg.sender].amountICO
            );
        }

        _transfer(address(this), _msgSender(), buyAmountToken);
        users[msg.sender].claimAt = block.timestamp;
    }

    function claimBNB() external onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function claimToken() external onlyOwner {
        uint256 remainAmountToken = this.balanceOf(address(this));
        this.transfer(msg.sender, remainAmountToken);
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {BEP20-allowance}.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {BEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
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
                "BEP20: transfer amount exceeds allowance"
            )
        );
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
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
     * the total supply.
     *
     * Requirements
     *
     * - `msg.sender` must be the token owner
     */
    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        uint256 availableAmount = _balances[sender] - users[sender].amountICO;
        uint256 unlockAmount = 0;
        if (
            users[sender].isSetup == true &&
            users[sender].amountICO > 0 &&
            availableAmount < amount
        ) {
            unlockAmount = this._getUnlockAmount(sender);
            availableAmount = availableAmount.add(unlockAmount);
            require(
                availableAmount < amount,
                "Not enough available balance to transfer"
            );
        }

        _balances[sender] = _balances[sender].sub(
            amount,
            "BEP20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);

        if (unlockAmount > 0) {
            users[sender].amountICO = users[sender].amountICO.sub(unlockAmount);
            users[sender].claimAt = block.timestamp;
        }

        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
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
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(
            amount,
            "BEP20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
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
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(
                amount,
                "BEP20: burn amount exceeds allowance"
            )
        );
    }

    function _calTotalAmountPerSec(uint256 amount)
        internal
        view
        returns (uint256)
    {
        uint256 numOfDays = (100 * 100) / percentClaimPerDate;
        uint256 totalSeconds = numOfDays * 24 * 60 * 60;
        uint256 totalAmountPerSec = amount / totalSeconds;
        return totalAmountPerSec;
    }

    function _getUnlockAmount(address account) external view returns (uint256) {
        if (users[account].isSetup == false || users[account].amountICO == 0)
            return 0;

        uint256 diff = block.timestamp - users[account].claimAt;
        uint256 claimAmount = users[account].amountClaimPerSec * diff;

        if (claimAmount > users[account].amountICO)
            claimAmount = users[account].amountICO;

        return claimAmount;
    }
}
