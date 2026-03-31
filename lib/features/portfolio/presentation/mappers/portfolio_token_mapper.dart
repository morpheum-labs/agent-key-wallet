import 'package:flutter/material.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/portfolio_balances.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/format_ether.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/format_token_units.dart';
import 'package:web3dart/web3dart.dart';

/// Maps [PortfolioBalances] / ETH snapshots to [TokenAsset] rows (single place for UI rules).
final portfolioTokenMapper = PortfolioTokenMapper();

final class PortfolioTokenMapper {
  List<TokenAsset> mapHomeRows(
    List<TokenAsset> base,
    AsyncSnapshot<PortfolioBalances> snapshot,
  ) {
    if (snapshot.hasError) {
      return _mapErrorRows(base);
    }
    if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
      return _mapLoadingRows(base);
    }
    if (snapshot.hasData) {
      return _mapDataRows(base, snapshot.data!);
    }
    return base;
  }

  List<TokenAsset> _mapErrorRows(List<TokenAsset> base) {
    return base.map((t) {
      if (t.symbol == 'ETH') {
        return t.copyWith(balanceDisplay: '—', fiatDisplay: r'$—');
      }
      if (t.symbol == 'USDC' && _hasUsdcContract(t)) {
        return t.copyWith(balanceDisplay: '—', fiatDisplay: r'$—');
      }
      return t;
    }).toList();
  }

  List<TokenAsset> _mapLoadingRows(List<TokenAsset> base) {
    return base.map((t) {
      if (t.symbol == 'ETH') {
        return t.copyWith(balanceDisplay: '…', fiatDisplay: r'$—');
      }
      if (t.symbol == 'USDC' && _hasUsdcContract(t)) {
        return t.copyWith(balanceDisplay: '…', fiatDisplay: r'$—');
      }
      return t;
    }).toList();
  }

  List<TokenAsset> _mapDataRows(List<TokenAsset> base, PortfolioBalances b) {
    return base.map((t) {
      if (t.symbol == 'ETH') {
        return t.copyWith(
          balanceDisplay: formatEtherForUi(b.eth),
          fiatDisplay: r'$—',
        );
      }
      if (t.symbol == 'USDC' && _hasUsdcContract(t)) {
        if (b.usdcSkipped) return t;
        if (b.usdcError != null) {
          return t.copyWith(balanceDisplay: '—', fiatDisplay: r'$—');
        }
        if (b.usdcRaw != null) {
          return t.copyWith(
            balanceDisplay: formatTokenUnits(b.usdcRaw!, t.unitDecimals),
            fiatDisplay: r'$—',
          );
        }
      }
      return t;
    }).toList();
  }

  bool _hasUsdcContract(TokenAsset t) =>
      t.erc20ContractAddress != null && t.erc20ContractAddress!.isNotEmpty;

  /// Token detail: ETH row only.
  List<TokenAsset> mapEthDetailRow(
    List<TokenAsset> base,
    AsyncSnapshot<EtherAmount> snapshot,
  ) {
    return base.map((t) {
      if (t.symbol != 'ETH') return t;
      if (snapshot.hasError) return t.copyWith(balanceDisplay: '—', fiatDisplay: r'$—');
      if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
        return t.copyWith(balanceDisplay: '…', fiatDisplay: r'$—');
      }
      if (snapshot.hasData) {
        return t.copyWith(
          balanceDisplay: formatEtherForUi(snapshot.data!),
          fiatDisplay: r'$—',
        );
      }
      return t;
    }).toList();
  }

  String ethHeadline(AsyncSnapshot<PortfolioBalances> snapshot) {
    if (snapshot.hasError) return 'Unavailable';
    if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
      return '…';
    }
    if (snapshot.hasData) {
      return '${formatEtherForUi(snapshot.data!.eth)} ETH';
    }
    return '—';
  }
}
