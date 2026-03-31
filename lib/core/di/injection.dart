import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/data/chain_settings_repository.dart';
import 'package:rainbow_flutter/features/auth/data/datasources/wallet_local_datasource.dart';
import 'package:rainbow_flutter/features/auth/data/datasources/wallet_private_key_datasource.dart';
import 'package:rainbow_flutter/features/auth/data/repositories/wallet_repository_impl.dart';
import 'package:rainbow_flutter/features/auth/domain/repositories/wallet_repository.dart';
import 'package:rainbow_flutter/features/auth/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:rainbow_flutter/features/portfolio/data/datasources/erc20_balance_remote_datasource.dart';
import 'package:rainbow_flutter/features/portfolio/data/datasources/eth_balance_remote_datasource.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_erc20_balance_usecase.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_eth_balance_usecase.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_wallet_balances_usecase.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/send_eth_usecase.dart';
import 'package:web3dart/web3dart.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final settingsBox = await Hive.openBox<dynamic>('settings');
  getIt.registerSingleton<ChainSettingsRepository>(
    ChainSettingsRepository(settingsBox),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<WalletLocalDataSource>(
    () => WalletLocalDataSource(getIt()),
  );
  getIt.registerLazySingleton<WalletPrivateKeyDataSource>(
    () => WalletPrivateKeyDataSource(getIt()),
  );
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      mnemonicStore: getIt(),
      privateKeyStore: getIt(),
    ),
  );
  getIt.registerLazySingleton<GenerateMnemonicUseCase>(
    GenerateMnemonicUseCase.new,
  );

  getIt.registerLazySingleton<http.Client>(http.Client.new);
  getIt.registerLazySingleton<Web3Client>(
    () {
      final net = getIt<ChainSettingsRepository>().selectedNetwork;
      final rpc = net is EvmWalletNetwork ? net.rpcUrl : EvmWalletNetwork.mainnet.rpcUrl;
      return Web3Client(rpc, getIt<http.Client>());
    },
  );
  getIt.registerLazySingleton<EthBalanceRemoteDataSource>(
    () => EthBalanceRemoteDataSource(client: getIt()),
  );
  getIt.registerLazySingleton<Erc20BalanceRemoteDataSource>(
    () => Erc20BalanceRemoteDataSource(client: getIt()),
  );
  getIt.registerLazySingleton<FetchEthBalanceUseCase>(
    () => FetchEthBalanceUseCase(getIt()),
  );
  getIt.registerLazySingleton<FetchErc20BalanceUseCase>(
    () => FetchErc20BalanceUseCase(getIt()),
  );
  getIt.registerLazySingleton<FetchWalletBalancesUseCase>(
    () => FetchWalletBalancesUseCase(getIt(), getIt(), getIt()),
  );
  getIt.registerLazySingleton<SendEthUseCase>(
    () => SendEthUseCase(getIt(), getIt()),
  );
}
