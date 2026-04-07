import "package:esim_open_source/presentation/enums/payment_type.dart";

class ProcessOrderPaymentParams {
  ProcessOrderPaymentParams({
    required this.billingCountryCode,
    required this.paymentIntentClientSecret,
    required this.customerId,
    required this.customerEphemeralKeySecret,
    this.merchantDisplayName = "Esim",
    this.testEnv = false,
    this.iccID,
    this.orderID,
  });

  final String billingCountryCode;
  final String paymentIntentClientSecret;
  final String customerId;
  final String customerEphemeralKeySecret;
  final String merchantDisplayName;
  final bool testEnv;
  final String? iccID;
  final String? orderID;
}

abstract class PaymentService {
  Future<void> prepareCheckout({
    required PaymentType paymentType,
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  });

  Future<PaymentResult> processOrderPayment({
    required PaymentType paymentType,
    required ProcessOrderPaymentParams params,
  });
}
