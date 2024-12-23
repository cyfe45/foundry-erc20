# OurToken - ERC20 Token Implementation

OurToken is a simple ERC20 token implementation built on the Ethereum blockchain using Solidity. This project demonstrates basic token functionality including minting, burning, and transferring tokens.

## Features

- ERC20 compliant token
- Minting new tokens
- Burning existing tokens
- Transferring tokens between addresses
- Initial supply set at deployment

## Contract Details

- Name: OurToken
- Symbol: OT
- Decimals: 18 (default for ERC20)
- Initial Supply: 100 ether (100 * 10^18 tokens)

## Project Structure

- `src/OurToken.sol`: Main token contract
- `script/DeployOurToken.sol`: Deployment script
- `test/OurTokenTest.t.sol`: Comprehensive test suite

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/our-token.git
   cd our-token
   ```

2. Install dependencies:
   ```
   forge install
   ```

