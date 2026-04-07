import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:flutter_stripe/flutter_stripe.dart";

class StripePayment {
  StripePayment._privateConstructor();

  static StripePayment? _instance;

  static StripePayment get instance {
    if (_instance == null) {
      _instance = StripePayment._privateConstructor();
      unawaited(_instance?._initialise());
    }

    return _instance!;
  }

  Future<void> _initialise() async {}

  Future<void> prepareCheckout({
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  }) async {
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = merchantIdentifier;
    Stripe.urlScheme = urlScheme;
    await Stripe.instance.applySettings();
  }

  Future<PaymentResult> processOrderPayment({
    required ProcessOrderPaymentParams params,
  }) async {
    try {
      // 1. create payment
      // create some billing details
      final BillingDetails billingDetails = BillingDetails(
        address: Address(
          city: null,
          country: params.billingCountryCode,
          line1: null,
          line2: null,
          postalCode: null,
          state: null,
        ),
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: params.paymentIntentClientSecret,
          merchantDisplayName: params.merchantDisplayName,
          customerId: params.customerId,
          customerEphemeralKeySecret: params.customerEphemeralKeySecret,
          applePay: PaymentSheetApplePay(
            merchantCountryCode: params.billingCountryCode,
          ),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: params.billingCountryCode,
            testEnv: params.testEnv,
          ),
          billingDetails: billingDetails,
        ),
      );

      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();
      return PaymentResult.completed;
    } on StripeException catch (e) {
      log("Error from Stripe: ${e.error.localizedMessage}");
      throw Exception(e.error.message);
    } catch (e) {
      log("Unforeseen error: $e");
      rethrow;
    }
  }
}
