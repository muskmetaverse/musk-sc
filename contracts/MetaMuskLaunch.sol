// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

// import "./interfaces/IERC20.sol";
// import "./libs/SafeERC20.sol";

// contract MetaMuskLaunch {
//     using SafeERC20 for IERC20;

//     IERC20 public token;
//     address public owner;
//     uint256 public startICO;
//     uint256 public endICO;
//     uint256 public totalAmountPerBNB;
//     uint256 public percentClaimPerDate;

//     struct UserInfo {
//         uint256 amountICO;
//         uint256 amountClaimPerSec;
//         uint256 claimAt;
//         bool isSetup;
//     }
//     mapping(address => UserInfo) public users;

//     constructor(
//         address _tokenAddress,
//         address _owner,
//         uint256 _startICO,
//         uint256 _endICO,
//         uint256 _totalAmountPerBNB,
//         uint256 _percentClaimPerDate
//     ) {
//         token = IERC20(_tokenAddress);
//         owner = _owner;
//         startICO = _startICO;
//         endICO = _endICO;
//         totalAmountPerBNB = _totalAmountPerBNB;
//         percentClaimPerDate = _percentClaimPerDate;
//     }

//     modifier onlyOwner() {
//         require(msg.sender == owner, "You are not owner.");
//         _;
//     }

//     function buyICO() external payable {
//         require(msg.value > 0, "value must be greater than 0");
//         require(block.timestamp >= startICO, "ICO time dose not start now");
//         require(block.timestamp <= endICO, "ICO time is expired");

//         uint256 buyAmountToken = msg.value * totalAmountPerBNB;
//         uint256 remainAmountToken = token.balanceOf(address(this));
//         require(
//             buyAmountToken <= remainAmountToken,
//             "Not enough amount token to buy"
//         );

//         if (users[msg.sender].isSetup == false) {
//             UserInfo storage userInfo = users[msg.sender];
//             userInfo.amountICO = buyAmountToken;
//             userInfo.amountClaimPerSec = _calTotalAmountPerSec(buyAmountToken);
//             userInfo.isSetup = true;
//         } else {
//             users[msg.sender].amountICO += buyAmountToken;
//             users[msg.sender].amountClaimPerSec = _calTotalAmountPerSec(
//                 users[msg.sender].amountICO
//             );
//         }

//         users[msg.sender].claimAt = block.timestamp;
//     }

//     function claimICO() external {
//         uint256 claimAmount = this.getClaimAmount(msg.sender);
//         require(claimAmount > 0, "Claim amount must be > 0");

//         if (claimAmount > users[msg.sender].amountICO) {
//             claimAmount = users[msg.sender].amountICO;
//             users[msg.sender].amountICO = 0;
//         } else {
//             users[msg.sender].amountICO -= claimAmount;
//         }

//         users[msg.sender].claimAt = block.timestamp;
//         token.safeTransfer(msg.sender, claimAmount);
//     }

//     function getClaimAmount(address account) external view returns (uint256) {
//         if (users[account].isSetup == false || users[account].amountICO == 0)
//             return 0;

//         uint256 diff = block.timestamp - users[account].claimAt;
//         uint256 claimAmount = users[account].amountClaimPerSec * diff;

//         if (claimAmount > users[account].amountICO)
//             claimAmount = users[account].amountICO;

//         return claimAmount;
//     }

//     function claimBNB() external onlyOwner {
//         payable(msg.sender).transfer(address(this).balance);
//     }

//     function claimToken() external onlyOwner {
//         uint256 remainAmountToken = token.balanceOf(address(this));
//         token.safeTransfer(msg.sender, remainAmountToken);
//     }

//     function _calTotalAmountPerSec(uint256 amount)
//         internal
//         view
//         returns (uint256)
//     {
//         uint256 numOfDays = (100 * 100) / percentClaimPerDate;
//         uint256 totalSeconds = numOfDays * 24 * 60 * 60;
//         uint256 totalAmountPerSec = amount / totalSeconds;
//         return totalAmountPerSec;
//     }
// }
