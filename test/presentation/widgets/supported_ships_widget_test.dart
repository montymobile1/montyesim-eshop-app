import "package:esim_open_source/domain/data/response/bundles/supported_ships_response_model.dart";
import "package:esim_open_source/presentation/widgets/circular_flag_icon.dart";
import "package:esim_open_source/presentation/widgets/supported_ships_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  List<SupportedShipsResponseModel> ships(int count) {
    return List<SupportedShipsResponseModel>.generate(
      count,
      (int i) => SupportedShipsResponseModel(country: "S$i", icon: "s$i"),
    );
  }

  group("SupportedShipsWidget Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders label and flags", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Ships",
              ships: ships(3),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
      tester.takeException(); // consume flag asset-load failures

      // Assert
      expect(find.byType(SupportedShipsWidget), findsOneWidget);
      expect(find.text("Ships"), findsOneWidget);
      expect(find.byType(CircularFlagIcon), findsNWidgets(3));
    });

    testWidgets("shows overflow indicator when over maxCountriesToShow",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Ships",
              ships: ships(8),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — only maxCountriesToShow (5) flags plus a "+3" indicator
      expect(find.byType(CircularFlagIcon), findsNWidgets(5));
      expect(find.text("+3"), findsOneWidget);
    });

    testWidgets("hides label when showLabel is false",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Hidden",
              ships: ships(2),
              backgroundColor: Colors.grey,
              showLabel: false,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.text("Hidden"), findsNothing);
    });

    testWidgets("renders showOnlyFlags layout", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Flags only",
              ships: ships(6),
              backgroundColor: Colors.grey,
              showOnlyFlags: true,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — label not shown in flags-only mode, overflow indicator present
      expect(find.text("Flags only"), findsNothing);
      expect(find.text("+1"), findsOneWidget);
    });

    testWidgets("renders in loading state", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Loading",
              ships: ships(3),
              backgroundColor: Colors.grey,
              isLoading: true,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.byType(SupportedShipsWidget), findsOneWidget);
    });

    testWidgets("renders with empty ships list", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Empty",
              ships: ships(0),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.byType(SupportedShipsWidget), findsOneWidget);
      expect(find.byType(CircularFlagIcon), findsNothing);
    });

    testWidgets("renders exactly at maxCountriesToShow without overflow",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Exact",
              ships: ships(5),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — no overflow indicator at the boundary
      expect(find.byType(CircularFlagIcon), findsNWidgets(5));
      expect(find.textContaining("+"), findsNothing);
    });

    testWidgets("applies custom labelStyle", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedShipsWidget(
              label: "Styled",
              ships: ships(1),
              backgroundColor: Colors.grey,
              labelStyle: const TextStyle(fontSize: 26),
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      final Text labelWidget = tester.widget<Text>(find.text("Styled"));
      expect(labelWidget.style?.fontSize, equals(26));
    });

    test("exposes constructor properties", () {
      // Arrange & Act
      final List<SupportedShipsResponseModel> data = ships(2);
      final SupportedShipsWidget widget = SupportedShipsWidget(
        label: "Title",
        ships: data,
        backgroundColor: Colors.blue,
        maxCountriesToShow: 7,
        size: 30,
        offset: 20,
        padding: 8,
        borderRadius: 10,
        showLabel: false,
        showOnlyFlags: true,
        isLoading: true,
      );

      // Assert
      expect(widget.label, equals("Title"));
      expect(widget.ships, equals(data));
      expect(widget.backgroundColor, equals(Colors.blue));
      expect(widget.maxCountriesToShow, equals(7));
      expect(widget.size, equals(30));
      expect(widget.offset, equals(20));
      expect(widget.padding, equals(8));
      expect(widget.borderRadius, equals(10));
      expect(widget.showLabel, isFalse);
      expect(widget.showOnlyFlags, isTrue);
      expect(widget.isLoading, isTrue);
    });

    test("exposes default constructor values", () {
      // Arrange & Act
      final SupportedShipsWidget widget = SupportedShipsWidget(
        label: "t",
        ships: ships(1),
        backgroundColor: Colors.grey,
      );

      // Assert
      expect(widget.isLoading, isFalse);
      expect(widget.maxCountriesToShow, equals(5));
      expect(widget.size, equals(25.0));
      expect(widget.offset, equals(15.0));
      expect(widget.padding, equals(12));
      expect(widget.borderRadius, equals(6));
      expect(widget.showLabel, isTrue);
      expect(widget.showOnlyFlags, isFalse);
      expect(widget.labelStyle, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key key = ValueKey<String>("ships");
      final SupportedShipsWidget widget = SupportedShipsWidget(
        key: key,
        label: "t",
        ships: ships(1),
        backgroundColor: Colors.grey,
      );

      // Assert
      expect(widget.key, equals(key));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final SupportedShipsWidget widget = SupportedShipsWidget(
        label: "t",
        ships: ships(1),
        backgroundColor: Colors.grey,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "isLoading",
        "countries",
        "maxCountriesToShow",
        "size",
        "offset",
        "padding",
        "borderRadius",
        "backgroundColor",
        "labelStyle",
        "label",
        "showLabel",
        "showOnlyFlags",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(supportedCountriesWidgetPreview()),
      );
      tester.takeException();

      // Assert
      expect(find.byType(SupportedShipsWidget), findsOneWidget);
      expect(find.text("Supported Countries"), findsOneWidget);
    });
  });
}
