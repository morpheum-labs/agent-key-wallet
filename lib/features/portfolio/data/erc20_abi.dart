/// Minimal ERC-20 ABI for [balanceOf].
const String kErc20BalanceOfAbiJson = '''
[
  {
    "constant": true,
    "inputs": [{"name": "account", "type": "address"}],
    "name": "balanceOf",
    "outputs": [{"name": "", "type": "uint256"}],
    "type": "function"
  }
]
''';
