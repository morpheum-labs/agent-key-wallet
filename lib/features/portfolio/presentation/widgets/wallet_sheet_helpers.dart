import 'package:flutter/material.dart';

import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_bottom_sheet.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/receive_sheet_content.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/send_sheet_content.dart';

Future<void> showWalletSendSheet(BuildContext context) {
  final network = AppLocator.network;
  final evm = network is EvmWalletNetwork ? network : null;
  return showRainbowModalBottomSheet<void>(
    context: context,
    title: evm != null ? 'Send ${evm.nativeSymbol}' : 'Send',
    builder: (sheetContext) => SendSheetContent(
      onDismiss: () => Navigator.of(sheetContext).pop(),
    ),
  );
}

Future<void> showWalletReceiveSheet(BuildContext context) {
  return showRainbowModalBottomSheet<void>(
    context: context,
    title: 'Receive',
    builder: (sheetContext) => ReceiveSheetContent(
      onClose: () => Navigator.of(sheetContext).pop(),
    ),
  );
}
