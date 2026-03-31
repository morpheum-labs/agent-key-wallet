/// High-level execution environment for a [WalletNetwork].
///
/// New ecosystems (Move, Cosmos, etc.) add a value here and a [WalletNetwork] subtype.
enum ChainFamily {
  /// Ethereum and EVM-compatible L1/L2 (JSON-RPC + optional ERC-20).
  evm,

  /// Solana (RPC + SPL token program when implemented).
  solana,

  /// Bitcoin and similar UTXO chains.
  utxo,
}
