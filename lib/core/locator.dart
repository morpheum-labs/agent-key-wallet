import 'package:rainbow_flutter/core/config/chain_config.dart';
import 'package:rainbow_flutter/core/data/chain_settings_repository.dart';
import 'package:rainbow_flutter/core/di/injection.dart';

/// Read-only access to registered app services (prefer over repeating `getIt<…>()`).
abstract final class AppLocator {
  static ChainSettingsRepository get chainSettings => getIt<ChainSettingsRepository>();

  static ChainConfig get chain => chainSettings.selectedSync;
}
