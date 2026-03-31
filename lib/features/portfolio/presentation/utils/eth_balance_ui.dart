import 'package:flutter/material.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/format_ether.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/format_token_units.dart';
import 'package:web3dart/web3dart.dart';

List<TokenAsset> applyEthSnapshot(
  List<TokenAsset> base,
  AsyncSnapshot<EtherAmount> snap,
) {
  return base.map((t) {
    if (t.symbol != 'ETH') return t;
    if (snap.hasError) return t.copyWith(balanceDisplay: '—', fiatDisplay: r'$—');
    if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
      return t.copyWith(balanceDisplay: '…', fiatDisplay: r'$—');
    }
    if (snap.hasData) {
      return t.copyWith(
        balanceDisplay: formatEtherForUi(snap.data!),
        fiatDisplay: r'$—',
      );
    }
    return t;
  }).toList();
}

List<TokenAsset> applyEthAndUsdcSnapshots(
  List<TokenAsset> base,
  AsyncSnapshot<EtherAmount> ethSnap,
  AsyncSnapshot<BigInt?> usdcSnap,
) {
  final withEth = applyEthSnapshot(base, ethSnap);
  return withEth.map((t) {
    if (t.symbol != 'USDC' || t.erc20ContractAddress == null || t.erc20ContractAddress!.isEmpty) {
      return t;
    }
    if (usdcSnap.hasError) {
      return t.copyWith(balanceDisplay: '—', fiatDisplay: r'$—');
    }
    if (usdcSnap.connectionState == ConnectionState.waiting && !usdcSnap.hasData) {
      return t.copyWith(balanceDisplay: '…', fiatDisplay: r'$—');
    }
    if (usdcSnap.hasData && usdcSnap.data != null) {
      return t.copyWith(
        balanceDisplay: formatTokenUnits(usdcSnap.data!, t.unitDecimals),
        fiatDisplay: r'$—',
      );
    }
    return t;
  }).toList();
}

String ethBalanceHeadline(AsyncSnapshot<EtherAmount> snap) {
  if (snap.hasError) return 'Unavailable';
  if (snap.connectionState == ConnectionState.waiting && !snap.hasData) return '…';
  if (snap.hasData) return '${formatEtherForUi(snap.data!)} ETH';
  return '—';
}
