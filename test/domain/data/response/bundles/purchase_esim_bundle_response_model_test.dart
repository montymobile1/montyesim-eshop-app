import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/supported_ships_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/transaction_history_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for PurchaseEsimBundleResponseModel
void main() {
  group("PurchaseEsimBundleResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Arrange
      final BundleCategoryResponseModel category =
          BundleCategoryResponseModel(type: "CRUISE");
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
      ];

      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        isTopupAllowed: true,
        planStarted: true,
        bundleExpired: false,
        labelName: "Test Label",
        orderNumber: "ORDER123",
        orderStatus: "active",
        bundleCode: "BUNDLE001",
        bundleCategory: category,
        bundleName: "Test Bundle",
        countries: countries,
      );

      // Assert
      expect(model.isTopupAllowed, true);
      expect(model.planStarted, true);
      expect(model.bundleExpired, false);
      expect(model.labelName, "Test Label");
      expect(model.orderNumber, "ORDER123");
      expect(model.orderStatus, "active");
      expect(model.bundleCode, "BUNDLE001");
      expect(model.bundleCategory, category);
      expect(model.bundleName, "Test Bundle");
      expect(model.countries, countries);
    });

    test("constructor with all null values", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel();

      // Assert
      expect(model.isTopupAllowed, isNull);
      expect(model.planStarted, isNull);
      expect(model.bundleExpired, isNull);
      expect(model.labelName, isNull);
      expect(model.orderNumber, isNull);
    });

    test("getStatusText returns active for active status", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        orderStatus: "active",
      );

      // Assert
      expect(model.getStatusText(), isNotEmpty);
    });

    test("getStatusText returns inactive for inactive status", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        orderStatus: "inactive",
      );

      // Assert
      expect(model.getStatusText(), isNotEmpty);
    });

    test("getStatusText returns expired for expired status", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        orderStatus: "expired",
      );

      // Assert
      expect(model.getStatusText(), isNotEmpty);
    });

    test("getStatusText returns empty for unknown status", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        orderStatus: "unknown",
      );

      // Assert
      expect(model.getStatusText(), "");
    });

    test("copyWith updates single field", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel(
        orderStatus: "active",
        bundleName: "Original",
      );

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          orderInfo: PurchaseOrderInfoParams(orderStatus: "inactive"),
        ),
      );

      // Assert
      expect(updated.orderStatus, "inactive");
      expect(updated.bundleName, "Original");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel(
        orderStatus: "active",
        bundleName: "Original",
        isTopupAllowed: true,
      );

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          orderInfo: PurchaseOrderInfoParams(orderStatus: "expired"),
          bundleInfo: BundleInfoParams(bundleName: "Updated"),
        ),
      );

      // Assert
      expect(updated.orderStatus, "expired");
      expect(updated.bundleName, "Updated");
      expect(updated.isTopupAllowed, true);
    });

    test("copyWith creates new instance", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel(
        orderStatus: "active",
      );

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          orderInfo: PurchaseOrderInfoParams(orderStatus: "inactive"),
        ),
      );

      // Assert
      expect(identical(original, updated), false);
      expect(original.orderStatus, "active");
      expect(updated.orderStatus, "inactive");
    });

    test("mockItems returns non-empty list", () {
      // Act
      final List<PurchaseEsimBundleResponseModel> items =
          PurchaseEsimBundleResponseModel.mockItems();

      // Assert
      expect(items, isNotEmpty);
      expect(items.length, greaterThan(0));
    });

    test("mockItems all items have required fields", () {
      // Act
      final List<PurchaseEsimBundleResponseModel> items =
          PurchaseEsimBundleResponseModel.mockItems();

      // Assert
      for (final PurchaseEsimBundleResponseModel item in items) {
        expect(item.bundleName, isNotNull);
        expect(item.iccid, isNotNull);
        expect(item.countries, isNotNull);
      }
    });

    test("getDisplayName returns bundleName when no transactionHistory", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        bundleName: "Test Bundle",
        transactionHistory: null,
      );

      // Assert
      expect(model.getDisplayName(), "Test Bundle");
    });

    test("getDisplayName returns bundleName when transactionHistory is empty",
        () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        bundleName: "Test Bundle",
        transactionHistory: <TransactionHistoryResponseModel>[],
      );

      // Assert
      expect(model.getDisplayName(), "Test Bundle");
    });

    test("countries list can be empty", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        countries: <CountryResponseModel>[],
      );

      // Assert
      expect(model.countries, isNotNull);
      expect(model.countries, isEmpty);
    });

    test("bundleMessage list can be empty", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        bundleMessage: <String>[],
      );

      // Assert
      expect(model.bundleMessage, isNotNull);
      expect(model.bundleMessage, isEmpty);
    });

    test("bundleMessage with multiple items", () {
      // Arrange
      final List<String> messages = <String>[
        "Message1",
        "Message2",
        "Message3"
      ];

      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        bundleMessage: messages,
      );

      // Assert
      expect(model.bundleMessage?.length, 3);
    });

    test("price as integer value", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        price: 100,
      );

      // Assert
      expect(model.price, 100);
    });

    test("price as decimal value", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        price: 99.99,
      );

      // Assert
      expect(model.price, 99.99);
    });

    test("validity as integer", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        validity: 30,
      );

      // Assert
      expect(model.validity, 30);
    });

    test("unlimited flag true", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        unlimited: true,
      );

      // Assert
      expect(model.unlimited, true);
    });

    test("unlimited flag false", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
      );

      // Assert
      expect(model.unlimited, false);
    });

    test("multiple instances are independent", () {
      // Act
      final PurchaseEsimBundleResponseModel model1 =
          PurchaseEsimBundleResponseModel(
        bundleName: "Bundle1",
        orderStatus: "active",
      );
      final PurchaseEsimBundleResponseModel model2 =
          PurchaseEsimBundleResponseModel(
        bundleName: "Bundle2",
        orderStatus: "inactive",
      );

      // Assert
      expect(model1.bundleName, "Bundle1");
      expect(model2.bundleName, "Bundle2");
      expect(model1.orderStatus, "active");
      expect(model2.orderStatus, "inactive");
    });

    test("response type is correct", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel();

      // Assert
      expect(model, isA<PurchaseEsimBundleResponseModel>());
    });

    test("all getters return constructor values", () {
      // Arrange
      final BundleCategoryResponseModel category =
          BundleCategoryResponseModel(type: "GLOBAL");
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
      ];
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(countryCode: "US"),
      ];
      final List<TransactionHistoryResponseModel> history =
          <TransactionHistoryResponseModel>[
        TransactionHistoryResponseModel(iccid: "999"),
      ];

      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        isTopupAllowed: true,
        planStarted: true,
        bundleExpired: false,
        labelName: "Label",
        orderNumber: "ORD1",
        orderStatus: "active",
        qrCodeValue: "QR",
        activationCode: "ACT",
        smdpAddress: "smdp.example.com",
        validityDate: "2026-01-01",
        iccid: "123",
        paymentDate: "1740667696",
        sharedWith: "friend@example.com",
        displayTitle: "Title",
        displaySubtitle: "Subtitle",
        bundleCode: "CODE",
        bundleCategory: category,
        bundleMarketingName: "Marketing",
        bundleName: "Bundle",
        countCountries: 5,
        currencyCode: "USD",
        gprsLimitDisplay: "5 GB",
        price: 9.99,
        priceDisplay: "9.99 USD",
        unlimited: false,
        validity: 30,
        validityLabel: "Day",
        planType: "data",
        activityPolicy: "policy",
        bundleMessage: <String>["msg"],
        countries: countries,
        supportedShips: ships,
        icon: "icon.png",
        transactionHistory: history,
      );

      // Assert
      expect(model.isTopupAllowed, true);
      expect(model.planStarted, true);
      expect(model.bundleExpired, false);
      expect(model.labelName, "Label");
      expect(model.orderNumber, "ORD1");
      expect(model.orderStatus, "active");
      expect(model.qrCodeValue, "QR");
      expect(model.activationCode, "ACT");
      expect(model.smdpAddress, "smdp.example.com");
      expect(model.validityDate, "2026-01-01");
      expect(model.iccid, "123");
      expect(model.paymentDate, "1740667696");
      expect(model.sharedWith, "friend@example.com");
      expect(model.displayTitle, "Title");
      expect(model.displaySubtitle, "Subtitle");
      expect(model.bundleCode, "CODE");
      expect(model.bundleCategory, category);
      expect(model.bundleMarketingName, "Marketing");
      expect(model.bundleName, "Bundle");
      expect(model.countCountries, 5);
      expect(model.currencyCode, "USD");
      expect(model.gprsLimitDisplay, "5 GB");
      expect(model.price, 9.99);
      expect(model.priceDisplay, "9.99 USD");
      expect(model.unlimited, false);
      expect(model.validity, 30);
      expect(model.validityLabel, "Day");
      expect(model.planType, "data");
      expect(model.activityPolicy, "policy");
      expect(model.bundleMessage, <String>["msg"]);
      expect(model.countries, countries);
      expect(model.supportedShips, ships);
      expect(model.icon, "icon.png");
      expect(model.transactionHistory, history);
    });

    test("isCruise returns true when category type is CRUISE", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        bundleCategory: BundleCategoryResponseModel(type: "CRUISE"),
      );

      // Assert
      expect(model.isCruise, true);
    });

    test("isCruise returns false when bundleCategory is null", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel();

      // Assert
      expect(model.isCruise, false);
    });

    test("getValidityDisplay returns formatted string for Day label", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        validityLabel: "Day",
        validity: 7,
      );

      // Assert
      expect(model.getValidityDisplay(), isNotNull);
      expect(model.getValidityDisplay(), contains("7"));
    });

    test("getValidityDisplay returns null when validityLabel is null", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        validity: 7,
      );

      // Assert
      expect(model.getValidityDisplay(), isNull);
    });

    test("getValidityDisplay returns null for unknown label", () {
      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        validityLabel: "Unknown",
        validity: 7,
      );

      // Assert
      expect(model.getValidityDisplay(), isNull);
    });

    test("getDisplayName returns bundle label from transactionHistory", () {
      // Arrange
      final List<TransactionHistoryResponseModel> history =
          <TransactionHistoryResponseModel>[
        TransactionHistoryResponseModel(
          bundle: BundleResponseModel(label: "History Label"),
        ),
      ];

      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        bundleName: "Bundle Name",
        transactionHistory: history,
      );

      // Assert
      expect(model.getDisplayName(), "History Label");
    });

    test("getDisplayName falls back to bundleName when label is empty", () {
      // Arrange
      final List<TransactionHistoryResponseModel> history =
          <TransactionHistoryResponseModel>[
        TransactionHistoryResponseModel(
          bundle: BundleResponseModel(label: ""),
        ),
      ];

      // Act
      final PurchaseEsimBundleResponseModel model =
          PurchaseEsimBundleResponseModel(
        bundleName: "Bundle Name",
        transactionHistory: history,
      );

      // Assert
      expect(model.getDisplayName(), "Bundle Name");
    });

    test("copyWith updates activation fields", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel(qrCodeValue: "OLD");

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          activation: EsimActivationParams(
            qrCodeValue: "NEW",
            activationCode: "AC",
            smdpAddress: "smdp",
            validityDate: "2026-01-01",
          ),
        ),
      );

      // Assert
      expect(updated.qrCodeValue, "NEW");
      expect(updated.activationCode, "AC");
      expect(updated.smdpAddress, "smdp");
      expect(updated.validityDate, "2026-01-01");
    });

    test("copyWith updates status fields", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel(isTopupAllowed: false);

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          status: BundlePlanStatusParams(
            isTopupAllowed: true,
            planStarted: true,
            bundleExpired: false,
          ),
        ),
      );

      // Assert
      expect(updated.isTopupAllowed, true);
      expect(updated.planStarted, true);
      expect(updated.bundleExpired, false);
    });

    test("copyWith updates display fields", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel(displayTitle: "Old");

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          display: BundleDisplayParams(
            displayTitle: "New",
            displaySubtitle: "Sub",
            icon: "icon.png",
          ),
        ),
      );

      // Assert
      expect(updated.displayTitle, "New");
      expect(updated.displaySubtitle, "Sub");
      expect(updated.icon, "icon.png");
    });

    test("copyWith updates pricing fields", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel(price: 1);

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          pricing: BundlePricingParams(
            currencyCode: "EUR",
            price: 25,
            priceDisplay: "25 EUR",
          ),
        ),
      );

      // Assert
      expect(updated.currencyCode, "EUR");
      expect(updated.price, 25);
      expect(updated.priceDisplay, "25 EUR");
    });

    test("copyWith updates coverage fields", () {
      // Arrange
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(countryCode: "US"),
      ];

      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel();

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          coverage: BundleCoverageParams(
            countCountries: 10,
            gprsLimitDisplay: "10 GB",
            unlimited: true,
            validity: 60,
            validityLabel: "Day",
            countries: <CountryResponseModel>[],
            supportedShips: ships,
          ),
        ),
      );

      // Assert
      expect(updated.countCountries, 10);
      expect(updated.gprsLimitDisplay, "10 GB");
      expect(updated.unlimited, true);
      expect(updated.validity, 60);
      expect(updated.validityLabel, "Day");
      expect(updated.supportedShips, ships);
    });

    test("copyWith updates bundleInfo and orderInfo fields", () {
      // Arrange
      final BundleCategoryResponseModel category =
          BundleCategoryResponseModel(type: "GLOBAL");
      final List<TransactionHistoryResponseModel> history =
          <TransactionHistoryResponseModel>[
        TransactionHistoryResponseModel(iccid: "1"),
      ];

      final PurchaseEsimBundleResponseModel original =
          PurchaseEsimBundleResponseModel();

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          bundleInfo: BundleInfoParams(
            bundleCode: "BC",
            bundleCategory: category,
            bundleMarketingName: "BM",
            bundleName: "BN",
            planType: "data",
            activityPolicy: "policy",
            bundleMessage: <String>["m"],
          ),
          orderInfo: PurchaseOrderInfoParams(
            labelName: "LN",
            orderNumber: "ON",
            orderStatus: "active",
            iccid: "IC",
            paymentDate: "PD",
            sharedWith: "SW",
            transactionHistory: history,
          ),
        ),
      );

      // Assert
      expect(updated.bundleCode, "BC");
      expect(updated.bundleCategory, category);
      expect(updated.bundleMarketingName, "BM");
      expect(updated.bundleName, "BN");
      expect(updated.planType, "data");
      expect(updated.activityPolicy, "policy");
      expect(updated.bundleMessage, <String>["m"]);
      expect(updated.labelName, "LN");
      expect(updated.orderNumber, "ON");
      expect(updated.orderStatus, "active");
      expect(updated.iccid, "IC");
      expect(updated.paymentDate, "PD");
      expect(updated.sharedWith, "SW");
      expect(updated.transactionHistory, history);
    });
  });
}
