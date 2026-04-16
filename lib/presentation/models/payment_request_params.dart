import "package:esim_open_source/presentation/enums/payment_type.dart";

class PaymentRequestParams {
  PaymentRequestParams({
    required this.secretParams,
    required this.idParams,
  });

  final PaymentRequestSecretParams secretParams;
  final PaymentRequestIDParams idParams;
}


class PaymentRequestSecretParams {
  PaymentRequestSecretParams({
    required this.paymentType,
    required this.publishableKey,
    required this.merchantIdentifier,
    required this.paymentIntentClientSecret,
    required this.customerEphemeralKeySecret,
    this.bearerToken,
    this.test = false,
  });

  final PaymentType paymentType;
  final String publishableKey;
  final String merchantIdentifier;
  final String paymentIntentClientSecret;
  final String customerEphemeralKeySecret;
  final String? bearerToken;
  final bool test;
}

class PaymentRequestIDParams {
  PaymentRequestIDParams({
    required this.orderID,
    required this.customerId,
    required this.billingCountryCode,
    required this.bundleCode,
    required this.bundleName,
  });

  final String orderID;
  final String customerId;
  final String billingCountryCode;
  final String bundleCode;
  final String bundleName;
}
