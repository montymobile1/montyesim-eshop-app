import "dart:async";

import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";

class DcbPayment {
  DcbPayment._privateConstructor();

  static DcbPayment? _instance;

  static DcbPayment get instance {
    if (_instance == null) {
      _instance = DcbPayment._privateConstructor();
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
    return PaymentResult.otpRequested;
  }
}
