import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:rainbow_flutter/features/auth/data/datasources/wallet_local_datasource.dart';
import 'package:rainbow_flutter/features/auth/data/datasources/wallet_private_key_datasource.dart';
import 'package:rainbow_flutter/features/auth/data/repositories/wallet_repository_impl.dart';
import 'package:rainbow_flutter/features/auth/domain/repositories/wallet_repository.dart';
import 'package:rainbow_flutter/features/auth/domain/usecases/generate_mnemonic_usecase.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
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
}
