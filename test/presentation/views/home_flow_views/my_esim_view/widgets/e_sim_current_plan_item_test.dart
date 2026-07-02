import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/supported_ships_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/circular_icon_button.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/e_sim_current_plan_item.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_widget.dart";
import "package:esim_open_source/presentation/widgets/supported_ships_widget.dart";
import "package:esim_open_source/presentation/widgets/top_up_button.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();
  late PurchaseEsimBundleResponseModel item;
  late ESimCurrentPlanItem eSimCurrentPlanItem;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();
    item = PurchaseEsimBundleResponseModel.mockItems().first;
    eSimCurrentPlanItem = ESimCurrentPlanItem(
      status: item.orderStatus ?? "",
      showUnlimitedData: item.unlimited ?? false,
      statusTextColor: Colors.white,
      statusBgColor: Colors.white,
      countryCode: "",
      title: item.displayTitle ?? "",
      subTitle: item.displaySubtitle ?? "",
      dataValue: item.gprsLimitDisplay ?? "",
      showInstallButton: false,
      showTopUpButton: item.isTopupAllowed ?? true,
      iconPath: item.icon ?? "",
      price: "",
      validity: item.getValidityDisplay() ?? "",
      expiryDate: DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(item.paymentDate ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      ),
      supportedCountries: item.countries ?? <CountryResponseModel>[],
      supportedShips: item.supportedShips ?? <SupportedShipsResponseModel>[],
      isCruise: item.isCruise,
      onEditName: () {},
      onTopUpClick: () {},
      onConsumptionClick: () async => <dynamic, dynamic>{},
      onQrCodeClick: () async => <dynamic, dynamic>{},
      onInstallClick: () async => <dynamic, dynamic>{},
      isLoading: false,
      onItemClick: () async => <dynamic, dynamic>{},
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  testWidgets("renders correctly with all components",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        eSimCurrentPlanItem,
      ),
    );
    await tester.pump();

    Finder gesture = find.byType(GestureDetector).at(0);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(TopUpButton);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(MainButton).at(0);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(MainButton).at(1);
    await tester.tap(gesture);
    await tester.pump();
  });

  testWidgets("renders correctly with all components",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        eSimCurrentPlanItem,
      ),
    );
    await tester.pump();

    Finder gesture = find.byType(MainButton).at(1);
    await tester.tap(gesture);
    await tester.pump();
  });

  testWidgets("renders correctly with show install button",
      (WidgetTester tester) async {
    eSimCurrentPlanItem = ESimCurrentPlanItem(
      status: item.orderStatus ?? "",
      showUnlimitedData: item.unlimited ?? false,
      statusTextColor: Colors.white,
      statusBgColor: Colors.white,
      countryCode: "",
      title: item.displayTitle ?? "",
      subTitle: item.displaySubtitle ?? "",
      dataValue: item.gprsLimitDisplay ?? "",
      showInstallButton: true,
      showTopUpButton: item.isTopupAllowed ?? true,
      iconPath: item.icon ?? "",
      price: "",
      validity: item.getValidityDisplay() ?? "",
      expiryDate: DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(item.paymentDate ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      ),
      supportedCountries: item.countries ?? <CountryResponseModel>[],
      supportedShips: item.supportedShips ?? <SupportedShipsResponseModel>[],
      isCruise: item.isCruise,
      onEditName: () {},
      onTopUpClick: () {},
      onConsumptionClick: () async => <dynamic, dynamic>{},
      onQrCodeClick: () async => <dynamic, dynamic>{},
      onInstallClick: () async => <dynamic, dynamic>{},
      isLoading: false,
      onItemClick: () => <dynamic, dynamic>{},
    );
    await tester.pumpWidget(
      createTestableWidget(
        eSimCurrentPlanItem,
      ),
    );
    await tester.pump();

    Finder gesture = find.byType(CircularIconButton).at(0);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(TopUpButton);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(MainButton).at(2);
    await tester.tap(gesture);
    await tester.pump();
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    eSimCurrentPlanItem.debugFillProperties(builder);
  });

  // Helper that builds an item with overridable branch-driving flags.
  ESimCurrentPlanItem buildItem({
    required bool isLoading,
    required bool isCruise,
    required bool showInstallButton,
    required bool showTopUpButton,
    List<CountryResponseModel>? supportedCountries,
    List<SupportedShipsResponseModel>? supportedShips,
  }) {
    return ESimCurrentPlanItem(
      status: item.orderStatus ?? "",
      showUnlimitedData: item.unlimited ?? false,
      statusTextColor: Colors.white,
      statusBgColor: Colors.white,
      countryCode: "",
      title: item.displayTitle ?? "",
      subTitle: item.displaySubtitle ?? "",
      dataValue: item.gprsLimitDisplay ?? "",
      showInstallButton: showInstallButton,
      showTopUpButton: showTopUpButton,
      iconPath: item.icon ?? "",
      price: "",
      validity: item.getValidityDisplay() ?? "",
      expiryDate: DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(item.paymentDate ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      ),
      supportedCountries: supportedCountries ?? <CountryResponseModel>[],
      supportedShips: supportedShips ?? <SupportedShipsResponseModel>[],
      isCruise: isCruise,
      onEditName: () {},
      onTopUpClick: () {},
      onConsumptionClick: () async => <dynamic, dynamic>{},
      onQrCodeClick: () async => <dynamic, dynamic>{},
      onInstallClick: () async => <dynamic, dynamic>{},
      isLoading: isLoading,
      onItemClick: () async => <dynamic, dynamic>{},
    );
  }

  testWidgets("hides supported widget and shows loading buttons when loading",
      (WidgetTester tester) async {
    // Arrange
    eSimCurrentPlanItem = buildItem(
      isLoading: true,
      isCruise: false,
      showInstallButton: false,
      showTopUpButton: true,
      supportedCountries: <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
      ],
    );

    // Act
    await tester.pumpWidget(createTestableWidget(eSimCurrentPlanItem));
    await tester.pump();

    // Assert — neither supported widget renders while loading
    expect(find.byType(SupportedCountriesWidget), findsNothing);
    expect(find.byType(SupportedShipsWidget), findsNothing);
  });

  testWidgets("shows SupportedShipsWidget when cruise with ships",
      (WidgetTester tester) async {
    // Arrange
    eSimCurrentPlanItem = buildItem(
      isLoading: false,
      isCruise: true,
      showInstallButton: false,
      showTopUpButton: true,
      supportedShips: <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "US", icon: "us"),
      ],
    );

    // Act
    await tester.pumpWidget(createTestableWidget(eSimCurrentPlanItem));
    await tester.pump();
    tester.takeException();

    // Assert
    expect(find.byType(SupportedShipsWidget), findsOneWidget);
  });

  testWidgets("hides ships widget when cruise with empty ships",
      (WidgetTester tester) async {
    // Arrange
    eSimCurrentPlanItem = buildItem(
      isLoading: false,
      isCruise: true,
      showInstallButton: false,
      showTopUpButton: true,
    );

    // Act
    await tester.pumpWidget(createTestableWidget(eSimCurrentPlanItem));
    await tester.pump();

    // Assert
    expect(find.byType(SupportedShipsWidget), findsNothing);
  });

  testWidgets("shows SupportedCountriesWidget when not cruise with countries",
      (WidgetTester tester) async {
    // Arrange
    eSimCurrentPlanItem = buildItem(
      isLoading: false,
      isCruise: false,
      showInstallButton: false,
      showTopUpButton: true,
      supportedCountries: <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
      ],
    );

    // Act
    await tester.pumpWidget(createTestableWidget(eSimCurrentPlanItem));
    await tester.pump();
    tester.takeException();

    // Assert
    expect(find.byType(SupportedCountriesWidget), findsOneWidget);
  });

  testWidgets("hides countries widget when not cruise with empty countries",
      (WidgetTester tester) async {
    // Arrange
    eSimCurrentPlanItem = buildItem(
      isLoading: false,
      isCruise: false,
      showInstallButton: false,
      showTopUpButton: true,
    );

    // Act
    await tester.pumpWidget(createTestableWidget(eSimCurrentPlanItem));
    await tester.pump();

    // Assert
    expect(find.byType(SupportedCountriesWidget), findsNothing);
  });

  testWidgets("install mode hides TopUpButton when showTopUpButton is false",
      (WidgetTester tester) async {
    // Arrange
    eSimCurrentPlanItem = buildItem(
      isLoading: false,
      isCruise: false,
      showInstallButton: true,
      showTopUpButton: false,
    );

    // Act
    await tester.pumpWidget(createTestableWidget(eSimCurrentPlanItem));
    await tester.pump();

    // Assert
    expect(find.byType(TopUpButton), findsNothing);
  });
}
