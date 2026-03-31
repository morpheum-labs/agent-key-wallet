/// One normal EVM transfer row from an explorer `txlist`-style API (Etherscan / Blockscout).
class EvmTxHistoryItem {
  const EvmTxHistoryItem({
    required this.hash,
    required this.from,
    required this.to,
    required this.valueWei,
    required this.timestampSec,
    required this.kind,
  });

  final String hash;
  final String from;
  final String? to;
  final String valueWei;
  final int timestampSec;
  final EvmTxKind kind;
}

enum EvmTxKind { incoming, outgoing, selfTransfer }
