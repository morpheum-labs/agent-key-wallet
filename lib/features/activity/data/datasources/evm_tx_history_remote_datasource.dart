import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rainbow_flutter/features/activity/domain/entities/evm_tx_history_item.dart';

/// Fetches recent normal transactions via Blockscout-compatible `module=account&action=txlist`.
///
/// No API key — uses public [Blockscout](https://www.blockscout.com/) endpoints for
/// Ethereum mainnet and Sepolia. Other chain IDs return an empty list until you add bases.
class EvmTxHistoryRemoteDataSource {
  EvmTxHistoryRemoteDataSource(this._client);

  final http.Client _client;

  static String? apiBaseForChainId(int chainId) {
    switch (chainId) {
      case 1:
        return 'https://eth.blockscout.com/api';
      case 11155111:
        return 'https://eth-sepolia.blockscout.com/api';
      default:
        return null;
    }
  }

  Future<List<EvmTxHistoryItem>> fetchRecent({
    required int chainId,
    required String address,
    int limit = 25,
  }) async {
    final base = apiBaseForChainId(chainId);
    if (base == null) return [];

    final uri = Uri.parse(base).replace(
      queryParameters: {
        'module': 'account',
        'action': 'txlist',
        'address': address,
        'startblock': '0',
        'endblock': '99999999',
        'page': '1',
        'offset': limit.toString(),
        'sort': 'desc',
      },
    );

    try {
      final res = await _client.get(uri).timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) return [];
      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) return [];

      final status = decoded['status']?.toString();
      final message = decoded['message']?.toString() ?? '';
      if (status != '1') {
        if (message.toLowerCase().contains('no transactions')) return [];
        return [];
      }

      final raw = decoded['result'];
      if (raw is! List<dynamic>) return [];

      final user = address.toLowerCase();
      final out = <EvmTxHistoryItem>[];

      for (final e in raw) {
        if (e is! Map<String, dynamic>) continue;
        final hash = e['hash'] as String?;
        final from = e['from'] as String?;
        final value = e['value'] as String?;
        final ts = e['timeStamp'];
        if (hash == null || from == null || value == null || ts == null) continue;

        final toStr = e['to'] as String?;
        final fromLc = from.toLowerCase();
        final toLc = toStr?.toLowerCase();

        final EvmTxKind kind;
        if (toLc != null && fromLc == user && toLc == user) {
          kind = EvmTxKind.selfTransfer;
        } else if (toLc == user) {
          kind = EvmTxKind.incoming;
        } else {
          kind = EvmTxKind.outgoing;
        }

        int sec;
        if (ts is int) {
          sec = ts;
        } else {
          sec = int.tryParse(ts.toString()) ?? 0;
        }

        out.add(
          EvmTxHistoryItem(
            hash: hash,
            from: fromLc,
            to: toLc,
            valueWei: value,
            timestampSec: sec,
            kind: kind,
          ),
        );
      }
      return out;
    } catch (_) {
      return [];
    }
  }
}
