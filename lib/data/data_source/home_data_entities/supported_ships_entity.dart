// entities/supported_ships_entity.dart
import "package:esim_open_source/data/data_source/home_data_entities/bundle_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/supported_ships_response_model_dto.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class SupportedShipsEntity {
  SupportedShipsEntity({
    required this.shipID,
    required this.country,
    required this.iso3Code,
    required this.zoneName,
    required this.countryCode,
    required this.alternativeCountry,
    required this.icon,
    required this.operatorList,
  });

  factory SupportedShipsEntity.fromModel(SupportedShipsResponseModelDto model) {
    return SupportedShipsEntity(
      shipID: model.id,
      country: model.country,
      iso3Code: model.iso3Code,
      zoneName: model.zoneName,
      countryCode: model.countryCode,
      alternativeCountry: model.alternativeCountry,
      icon: model.icon,
      operatorList: model.operatorList,
    );
  }
  @Id()
  int id = 0;

  final String? shipID;
  final String? country;
  final String? iso3Code;
  final String? zoneName;
  final String? countryCode;
  final String? icon;
  final List<String>? operatorList;

  String? alternativeCountry;

  final ToMany<BundleEntity> bundles = ToMany<BundleEntity>();

  SupportedShipsResponseModelDto toModel() {
    return SupportedShipsResponseModelDto(
      id: shipID,
      country: country,
      iso3Code: iso3Code,
      zoneName: zoneName,
      countryCode: countryCode,
      alternativeCountry: alternativeCountry,
      icon: icon,
      operatorList: operatorList,
    );
  }
}
