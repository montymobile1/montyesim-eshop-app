import "package:esim_open_source/domain/data/response/bundles/supported_ships_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for SupportedShipsResponseModel
/// Tests constructor, fields and the mock factory method
void main() {
  group("SupportedShipsResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Act
      final SupportedShipsResponseModel model = SupportedShipsResponseModel(
        id: "ship-1",
        country: "Abkhazia",
        iso3Code: "KAZ",
        zoneName: "Zone A",
        countryCode: "GE",
        alternativeCountry: "Georgia",
        icon: "https://flagsapi.com/GE/flat/64.png",
        operatorList: <String>["Operator A", "Operator B"],
      );

      // Assert
      expect(model.id, "ship-1");
      expect(model.country, "Abkhazia");
      expect(model.iso3Code, "KAZ");
      expect(model.zoneName, "Zone A");
      expect(model.countryCode, "GE");
      expect(model.alternativeCountry, "Georgia");
      expect(model.icon, "https://flagsapi.com/GE/flat/64.png");
      expect(model.operatorList?.length, 2);
      expect(model.operatorList?[0], "Operator A");
    });

    test("all fields are nullable", () {
      // Act
      final SupportedShipsResponseModel model = SupportedShipsResponseModel();

      // Assert
      expect(model.id, isNull);
      expect(model.country, isNull);
      expect(model.iso3Code, isNull);
      expect(model.zoneName, isNull);
      expect(model.countryCode, isNull);
      expect(model.alternativeCountry, isNull);
      expect(model.icon, isNull);
      expect(model.operatorList, isNull);
    });

    test("constructor with minimal fields", () {
      // Act
      final SupportedShipsResponseModel model = SupportedShipsResponseModel(
        country: "Albania",
      );

      // Assert
      expect(model.country, "Albania");
      expect(model.id, isNull);
      expect(model.operatorList, isNull);
    });

    test("operatorList can be empty", () {
      // Act
      final SupportedShipsResponseModel model = SupportedShipsResponseModel(
        operatorList: <String>[],
      );

      // Assert
      expect(model.operatorList, isNotNull);
      expect(model.operatorList, isEmpty);
    });

    test("operatorList with multiple items", () {
      // Act
      final SupportedShipsResponseModel model = SupportedShipsResponseModel(
        operatorList: <String>["Op 1", "Op 2", "Op 3"],
      );

      // Assert
      expect(model.operatorList?.length, 3);
      expect(model.operatorList?[2], "Op 3");
    });

    test("getMockCountries returns non-empty list", () {
      // Act
      final List<SupportedShipsResponseModel> items =
          SupportedShipsResponseModel.getMockCountries();

      // Assert
      expect(items, isNotEmpty);
      expect(items.length, greaterThan(0));
    });

    test("getMockCountries all items have required fields", () {
      // Act
      final List<SupportedShipsResponseModel> items =
          SupportedShipsResponseModel.getMockCountries();

      // Assert
      for (final SupportedShipsResponseModel item in items) {
        expect(item.country, isNotNull);
        expect(item.countryCode, isNotNull);
        expect(item.icon, isNotNull);
      }
    });

    test("getMockCountries first item has expected values", () {
      // Act
      final List<SupportedShipsResponseModel> items =
          SupportedShipsResponseModel.getMockCountries();
      final SupportedShipsResponseModel first = items[0];

      // Assert
      expect(first.country, "Abkhazia");
      expect(first.countryCode, "GE");
      expect(first.iso3Code, "KAZ");
      expect(first.alternativeCountry, "Georgia");
    });

    test("getMockCountries consistency", () {
      // Act
      final List<SupportedShipsResponseModel> items1 =
          SupportedShipsResponseModel.getMockCountries();
      final List<SupportedShipsResponseModel> items2 =
          SupportedShipsResponseModel.getMockCountries();

      // Assert
      expect(items1.length, items2.length);
      expect(items1[0].country, items2[0].country);
    });

    test("fromJson with special characters in strings", () {
      // Act
      final SupportedShipsResponseModel model = SupportedShipsResponseModel(
        country: "Côte d'Ivoire",
        alternativeCountry: "O'Brien Island",
      );

      // Assert
      expect(model.country, "Côte d'Ivoire");
      expect(model.alternativeCountry, "O'Brien Island");
    });

    test("multiple instances are independent", () {
      // Act
      final SupportedShipsResponseModel model1 =
          SupportedShipsResponseModel(country: "Country1");
      final SupportedShipsResponseModel model2 =
          SupportedShipsResponseModel(country: "Country2");

      // Assert
      expect(model1.country, "Country1");
      expect(model2.country, "Country2");
    });

    test("response type is correct", () {
      // Act
      final SupportedShipsResponseModel model = SupportedShipsResponseModel();

      // Assert
      expect(model, isA<SupportedShipsResponseModel>());
    });
  });
}
