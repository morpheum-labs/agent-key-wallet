import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/data/chain_settings_repository.dart';
import 'package:rainbow_flutter/core/di/injection.dart';

/// Read-only access to registered app services (prefer over repeating `getIt<…>()`).
abstract final class AppLocator {
  static ChainSettingsRepository get chainSettings => getIt<ChainSettingsRepository>();

  /// Currently selected network (EVM, Solana, Bitcoin, …).
  static WalletNetwork get network => chainSettings.selectedNetwork;
}
