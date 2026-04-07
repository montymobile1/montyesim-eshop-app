import "dart:async";

import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";

class WalletPayment {
  WalletPayment._privateConstructor();

  static WalletPayment? _instance;

  static WalletPayment get instance {
    if (_instance == null) {
      _instance = WalletPayment._privateConstructor();
      unawaited(_instance?._initialise());
    }

    return _instance!;
  }

  Future<void> _initialise() async {}

  Future<void> prepareCheckout({
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  }) async {}

  Future<PaymentResult> processOrderPayment({
    required ProcessOrderPaymentParams params,
  }) async {
    return PaymentResult.completed;
  }
}
