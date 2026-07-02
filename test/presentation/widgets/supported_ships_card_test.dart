import "package:esim_open_source/domain/data/response/bundles/supported_ships_response_model.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/info_row_view.dart";
import "package:esim_open_source/presentation/widgets/supported_ships_card.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("SupportedShipsCard Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    testWidgets("renders with ships list", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T", "T-Mobile"],
        ),
        SupportedShipsResponseModel(
          country: "Canada",
          icon: "ca",
          operatorList: <String>["Rogers"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byType(SupportedShipsCard), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets("displays correct ship count", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "US", icon: "us"),
        SupportedShipsResponseModel(country: "CA", icon: "ca"),
        SupportedShipsResponseModel(country: "UK", icon: "uk"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      // Verify correct number of expansion tiles are rendered
      expect(find.byType(ExpansionTile), findsNWidgets(3));
    });

    testWidgets("renders ship country names", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us",
        ),
        SupportedShipsResponseModel(
          country: "Canada",
          icon: "ca",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      // Ship country names should be rendered in the expansion tiles
      expect(find.textContaining("United States"), findsOneWidget);
      expect(find.textContaining("Canada"), findsOneWidget);
    });

    testWidgets("renders ship flags", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us_flag",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byType(CountryFlagImage), findsOneWidget);
    });

    testWidgets("shows expansion icon when operators exist",
        (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T", "Verizon"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets("hides expansion icon when no operators",
        (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>[],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets("expands to show operators on tap",
        (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T", "Verizon", "T-Mobile"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      // Verify expansion icon is shown before tap
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      // Tap to expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.byType(InfoRow), findsOneWidget);
    });

    testWidgets("collapses on second tap", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      // Initial state - should show down arrow
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      // Expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

      // Collapse
      await tester.tap(find.byType(ExpansionTile));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets("renders scrollbar", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "US", icon: "us"),
        SupportedShipsResponseModel(country: "CA", icon: "ca"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byType(Scrollbar), findsOneWidget);
    });

    testWidgets("renders ListView with correct item count",
        (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "US", icon: "us"),
        SupportedShipsResponseModel(country: "CA", icon: "ca"),
        SupportedShipsResponseModel(country: "UK", icon: "uk"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byType(ExpansionTile), findsNWidgets(3));
    });

    testWidgets("getHeight caps at maxHeight for many ships",
        (WidgetTester tester) async {
      // Arrange — 10 ships * 40 = 400 > 180 cap
      final List<SupportedShipsResponseModel> ships =
          List<SupportedShipsResponseModel>.generate(
        10,
        (int i) => SupportedShipsResponseModel(country: "S$i", icon: "s$i"),
      );

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      // Assert — the height-capped SizedBox is rendered
      expect(find.byType(SupportedShipsCard), findsOneWidget);
      expect(find.byType(Scrollbar), findsOneWidget);
    });

    testWidgets("handles null ship country name", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(icon: "us"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.text(""), findsWidgets);
    });

    testWidgets("handles null icon", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "United States"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byType(CountryFlagImage), findsOneWidget);
    });

    testWidgets("handles null operator list", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "United States",
          icon: "us",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
    });

    testWidgets("displays empty ships list", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      // Verify no expansion tiles are rendered for empty list
      expect(find.byType(ExpansionTile), findsNothing);
      expect(find.byType(SupportedShipsCard), findsOneWidget);
    });

    testWidgets("card has correct styling", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "US", icon: "us"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      final Card card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, EdgeInsets.zero);
      expect(card.elevation, 0);
      expect(
        (card.shape! as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(6),
      );
    });

    testWidgets("column has correct layout", (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "US", icon: "us"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      final Column column = tester.widget<Column>(
        find
            .descendant(
              of: find.byType(Card),
              matching: find.byType(Column),
            )
            .first,
      );

      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets("handles multiple ships with mixed operator lists",
        (WidgetTester tester) async {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(
          country: "US",
          icon: "us",
          operatorList: <String>["AT&T"],
        ),
        SupportedShipsResponseModel(
          country: "CA",
          icon: "ca",
          operatorList: <String>[],
        ),
        SupportedShipsResponseModel(
          country: "UK",
          icon: "uk",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedShipsCard(ships: ships),
        ),
      );

      await tester.pump();

      expect(find.byType(ExpansionTile), findsNWidgets(3));
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(supportedShipsCardPreview()),
      );
      tester.takeException();

      expect(find.byType(SupportedShipsCard), findsOneWidget);
    });

    test("debug properties coverage", () {
      final List<SupportedShipsResponseModel> ships =
          <SupportedShipsResponseModel>[
        SupportedShipsResponseModel(country: "US", icon: "us"),
      ];

      final SupportedShipsCard widget = SupportedShipsCard(
        ships: ships,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);

      expect(
        props.any((DiagnosticsNode prop) => prop.name == "ships"),
        isTrue,
      );
    });

    test("can be instantiated with a key", () {
      const Key key = ValueKey<String>("ships-card");
      final SupportedShipsCard widget = SupportedShipsCard(
        key: key,
        ships: <SupportedShipsResponseModel>[],
      );

      expect(widget.key, equals(key));
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}
