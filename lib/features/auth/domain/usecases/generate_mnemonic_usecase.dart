import 'package:bip39/bip39.dart' as bip39;

class GenerateMnemonicUseCase {
  String call() => bip39.generateMnemonic();
}
