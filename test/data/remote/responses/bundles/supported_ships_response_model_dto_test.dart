import "package:esim_open_source/data/remote/responses/bundles/supported_ships_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/supported_ships_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for SupportedShipsResponseModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("SupportedShipsResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "id": "ship-1",
        "alternative_country": "Georgia",
        "country": "Abkhazia",
        "country_code": "GE",
        "iso3_code": "KAZ",
        "zone_name": "Zone A",
        "icon": "https://flagsapi.com/GE/flat/64.png",
        "operator_list": <String>["Operator A", "Operator B"],
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.id, "ship-1");
      expect(model.alternativeCountry, "Georgia");
      expect(model.country, "Abkhazia");
      expect(model.countryCode, "GE");
      expect(model.iso3Code, "KAZ");
      expect(model.zoneName, "Zone A");
      expect(model.icon, "https://flagsapi.com/GE/flat/64.png");
      expect(model.operatorList?.length, 2);
      expect(model.operatorList?[0], "Operator A");
      expect(model.operatorList?[1], "Operator B");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.id, isNull);
      expect(model.alternativeCountry, isNull);
      expect(model.country, isNull);
      expect(model.countryCode, isNull);
      expect(model.iso3Code, isNull);
      expect(model.zoneName, isNull);
      expect(model.icon, isNull);
      expect(model.operatorList, <String>[]);
    });

    test("fromJson handles null operator_list", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "country": "Albania",
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.country, "Albania");
      expect(model.operatorList, isNotNull);
      expect(model.operatorList, isEmpty);
    });

    test("fromJson with explicit null operator_list", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "operator_list": null,
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.operatorList, isEmpty);
    });

    test("fromJson parses operator_list with multiple items", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "operator_list": <String>["Op 1", "Op 2", "Op 3"],
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.operatorList?.length, 3);
      expect(model.operatorList?[0], "Op 1");
      expect(model.operatorList?[2], "Op 3");
    });

    test("fromJson handles empty operator_list", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "operator_list": <String>[],
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.operatorList, isNotNull);
      expect(model.operatorList, isEmpty);
    });

    test("constructor assigns values correctly", () {
      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto(
        id: "ship-2",
        country: "Albania",
        iso3Code: "ALB",
        zoneName: "Zone B",
        countryCode: "AL",
        alternativeCountry: "Albania",
        icon: "https://flagsapi.com/AL/flat/64.png",
        operatorList: <String>["Op A"],
      );

      // Assert
      expect(model.id, "ship-2");
      expect(model.country, "Albania");
      expect(model.iso3Code, "ALB");
      expect(model.zoneName, "Zone B");
      expect(model.countryCode, "AL");
      expect(model.alternativeCountry, "Albania");
      expect(model.icon, "https://flagsapi.com/AL/flat/64.png");
      expect(model.operatorList, <String>["Op A"]);
    });

    test("all fields are nullable", () {
      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto();

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

    test("toJson returns correct map with all fields", () {
      // Arrange
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto(
        id: "ship-3",
        country: "Algeria",
        iso3Code: "DZA",
        zoneName: "Zone C",
        countryCode: "DZ",
        alternativeCountry: "Algeria",
        icon: "https://flagsapi.com/DZ/flat/64.png",
        operatorList: <String>["Op X", "Op Y"],
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["id"], "ship-3");
      expect(json["country"], "Algeria");
      expect(json["country_code"], "DZ");
      expect(json["iso2_code"], "DZA");
      expect(json["zone_name"], "Zone C");
      expect(json["alternative_country"], "Algeria");
      expect(json["icon"], "https://flagsapi.com/DZ/flat/64.png");
      expect(json["operator_list"], <String>["Op X", "Op Y"]);
    });

    test("toJson handles null fields", () {
      // Arrange
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["id"], isNull);
      expect(json["country"], isNull);
      expect(json["country_code"], isNull);
      expect(json["iso2_code"], isNull);
      expect(json["zone_name"], isNull);
      expect(json["alternative_country"], isNull);
      expect(json["icon"], isNull);
      expect(json["operator_list"], isNull);
    });

    test("getMockCountries returns non-empty list", () {
      // Act
      final List<SupportedShipsResponseModelDto> items =
          SupportedShipsResponseModelDto.getMockCountries();

      // Assert
      expect(items, isNotEmpty);
      expect(items.length, greaterThan(0));
    });

    test("getMockCountries all items have required fields", () {
      // Act
      final List<SupportedShipsResponseModelDto> items =
          SupportedShipsResponseModelDto.getMockCountries();

      // Assert
      for (final SupportedShipsResponseModelDto item in items) {
        expect(item.country, isNotNull);
        expect(item.countryCode, isNotNull);
        expect(item.icon, isNotNull);
      }
    });

    test("getMockCountries first item has expected values", () {
      // Act
      final List<SupportedShipsResponseModelDto> items =
          SupportedShipsResponseModelDto.getMockCountries();
      final SupportedShipsResponseModelDto first = items[0];

      // Assert
      expect(first.country, "Abkhazia");
      expect(first.countryCode, "GE");
      expect(first.iso3Code, "KAZ");
      expect(first.alternativeCountry, "Georgia");
    });

    test("toDomain maps all fields to domain model", () {
      // Arrange
      final SupportedShipsResponseModelDto dto = SupportedShipsResponseModelDto(
        id: "ship-4",
        country: "Andorra",
        iso3Code: "AND",
        zoneName: "Zone D",
        countryCode: "AD",
        alternativeCountry: "Andorra",
        icon: "https://flagsapi.com/AD/flat/64.png",
        operatorList: <String>["Op Z"],
      );

      // Act
      final SupportedShipsResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.id, "ship-4");
      expect(domain.country, "Andorra");
      expect(domain.iso3Code, "AND");
      expect(domain.zoneName, "Zone D");
      expect(domain.countryCode, "AD");
      expect(domain.alternativeCountry, "Andorra");
      expect(domain.icon, "https://flagsapi.com/AD/flat/64.png");
      expect(domain.operatorList, <String>["Op Z"]);
    });

    test("toDomain handles null fields", () {
      // Arrange
      final SupportedShipsResponseModelDto dto =
          SupportedShipsResponseModelDto();

      // Act
      final SupportedShipsResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.id, isNull);
      expect(domain.country, isNull);
      expect(domain.operatorList, isNull);
    });

    test("fromDomain maps all fields from domain model", () {
      // Arrange
      final SupportedShipsResponseModel domain = SupportedShipsResponseModel(
        id: "ship-5",
        country: "Angola",
        iso3Code: "AGO",
        zoneName: "Zone E",
        countryCode: "AO",
        alternativeCountry: "Angola",
        icon: "https://flagsapi.com/AO/flat/64.png",
        operatorList: <String>["Op W"],
      );

      // Act
      final SupportedShipsResponseModelDto dto =
          SupportedShipsResponseModelDto().fromDomain(domain);

      // Assert
      expect(dto.id, "ship-5");
      expect(dto.country, "Angola");
      expect(dto.iso3Code, "AGO");
      expect(dto.zoneName, "Zone E");
      expect(dto.countryCode, "AO");
      expect(dto.alternativeCountry, "Angola");
      expect(dto.icon, "https://flagsapi.com/AO/flat/64.png");
      expect(dto.operatorList, <String>["Op W"]);
    });

    test("fromDomain handles null model", () {
      // Act
      final SupportedShipsResponseModelDto dto =
          SupportedShipsResponseModelDto().fromDomain(null);

      // Assert
      expect(dto.id, isNull);
      expect(dto.country, isNull);
      expect(dto.countryCode, isNull);
      expect(dto.operatorList, isNull);
    });

    test("fromJson handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "country": "",
        "country_code": "",
        "zone_name": "",
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.country, "");
      expect(model.countryCode, "");
      expect(model.zoneName, "");
    });

    test("fromJson with special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "country": "Côte d'Ivoire",
        "alternative_country": "O'Brien Island",
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(json);

      // Assert
      expect(model.country, "Côte d'Ivoire");
      expect(model.alternativeCountry, "O'Brien Island");
    });

    test("multiple instances are independent", () {
      // Act
      final SupportedShipsResponseModelDto model1 =
          SupportedShipsResponseModelDto(country: "Country1");
      final SupportedShipsResponseModelDto model2 =
          SupportedShipsResponseModelDto(country: "Country2");

      // Assert
      expect(model1.country, "Country1");
      expect(model2.country, "Country2");
    });

    test("roundtrip fromJson and toJson preserves shared keys", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "id": "ship-6",
        "country": "Argentina",
        "country_code": "AR",
        "zone_name": "Zone F",
        "alternative_country": "Argentina",
        "icon": "https://flagsapi.com/AR/flat/64.png",
        "operator_list": <String>["Op 1"],
      };

      // Act
      final SupportedShipsResponseModelDto model =
          SupportedShipsResponseModelDto.fromJson(originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["id"], originalJson["id"]);
      expect(resultJson["country"], originalJson["country"]);
      expect(resultJson["country_code"], originalJson["country_code"]);
      expect(resultJson["zone_name"], originalJson["zone_name"]);
      expect(
        resultJson["alternative_country"],
        originalJson["alternative_country"],
      );
      expect(resultJson["icon"], originalJson["icon"]);
      expect(resultJson["operator_list"], originalJson["operator_list"]);
    });
  });
}
