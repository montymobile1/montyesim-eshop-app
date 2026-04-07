// repositories/home_data_repository.dart
import "package:esim_open_source/data/data_source/home_data_entities/bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/bundle_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/bundle_type.dart";
import "package:esim_open_source/data/data_source/home_data_entities/country_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/home_data_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/region_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";
import "package:esim_open_source/objectbox.g.dart";

class HomeLocalDataSource {
  HomeLocalDataSource(this._store)
      : _homeDataBox = _store.box<HomeDataEntity>(),
        _countryBox = _store.box<CountryEntity>(),
        _bundleCategoryBox = _store.box<BundleCategoryEntity>();
  final Store _store;
  final Box<HomeDataEntity> _homeDataBox;
  final Box<CountryEntity> _countryBox;
  final Box<BundleCategoryEntity> _bundleCategoryBox;

  Future<void> saveHomeData(HomeDataResponseModel data) async {
    _store.runInTransaction(TxMode.write, () {
      final HomeDataEntity homeData =
          HomeDataEntity(lastUpdated: DateTime.now())..version = data.version;

      _saveRegions(data.regions, homeData);
      _saveCountries(data.countries, homeData);
      _saveBundles(data.globalBundles, BundleType.global, homeData);
      _saveBundles(data.cruiseBundles, BundleType.cruise, homeData);

      _homeDataBox.put(homeData);
    });
  }

  void _saveRegions(
      List<RegionsResponseModel>? regions, HomeDataEntity homeData,) {
    if (regions == null) {
      return;
    }

    for (final RegionsResponseModel region in regions) {
      final RegionEntity regionEntity = RegionEntity.fromModel(region);
      homeData.regions.add(regionEntity);
    }
  }

  void _saveCountries(
      List<CountryResponseModel>? countries, HomeDataEntity homeData,) {
    if (countries == null) {
      return;
    }

    for (final CountryResponseModel country in countries) {
      final CountryEntity countryEntity = CountryEntity.fromModel(country);
      homeData.countries.add(countryEntity);
    }
  }

  void _saveBundles(List<BundleResponseModel>? bundles, BundleType bundleType,
      HomeDataEntity homeData,) {
    if (bundles == null) {
      return;
    }

    for (final BundleResponseModel bundle in bundles) {
      final BundleEntity bundleEntity = _createBundleEntity(bundle, bundleType);
      homeData.bundles.add(bundleEntity);
    }
  }

  BundleEntity _createBundleEntity(
      BundleResponseModel bundle, BundleType bundleType,) {
    final BundleEntity bundleEntity = BundleEntity.fromModel(bundle, bundleType);

    _attachBundleCategory(bundle, bundleEntity);
    _linkBundleCountries(bundle, bundleEntity);

    return bundleEntity;
  }

  void _attachBundleCategory(
      BundleResponseModel bundle, BundleEntity bundleEntity,) {
    if (bundle.bundleCategory == null) {
      return;
    }

    final BundleCategoryEntity categoryEntity =
        BundleCategoryEntity.fromModel(bundle.bundleCategory!);
    _bundleCategoryBox.put(categoryEntity);
    bundleEntity.bundleCategory.target = categoryEntity;
  }

  void _linkBundleCountries(
      BundleResponseModel bundle, BundleEntity bundleEntity,) {
    if (bundle.countries == null) {
      return;
    }

    for (final CountryResponseModel country in bundle.countries!) {
      final CountryEntity countryEntity = _findOrCreateCountry(country);
      bundleEntity.countries.add(countryEntity);
    }
  }

  CountryEntity _findOrCreateCountry(CountryResponseModel country) {
    final CountryEntity? existingCountry = _countryBox
        .query(CountryEntity_.iso3Code.equals(country.iso3Code ?? ""))
        .build()
        .findFirst();

    if (existingCountry != null) {
      return existingCountry;
    }

    final CountryEntity newCountry = CountryEntity.fromModel(country);
    _countryBox.put(newCountry);
    return newCountry;
  }

  HomeDataResponseModel? getHomeData() {
    final HomeDataEntity? homeData = _homeDataBox
        .query()
        .order(HomeDataEntity_.lastUpdated, flags: Order.descending)
        .build()
        .findFirst();

    return homeData?.toModel();
  }

  Future<void> clearCache() async {
    _store.runInTransaction(TxMode.write, () {
      _homeDataBox.removeAll();
      _countryBox.removeAll();
      _bundleCategoryBox.removeAll();
    });
  }
}
