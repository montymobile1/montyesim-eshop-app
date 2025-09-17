import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/app/banner_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/dynamic_page_response.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response.dart";
import "package:esim_open_source/data/remote/responses/core/string_response.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/data/api_app.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/utils/value_stream.dart";

class ApiAppRepositoryImpl implements ApiAppRepository {
  ApiAppRepositoryImpl(this.apiApp);

  final APIApp apiApp;

  final ValueStream<Resource<List<BannerResponseModel>?>> _bannersStream =
      ValueStream<Resource<List<BannerResponseModel>?>>();

  @override
  FutureOr<Resource<EmptyResponse?>> addDevice({
    required String fcmToken,
    required String manufacturer,
    required String deviceModel,
    required String deviceOs,
    required String deviceOsVersion,
    required String appVersion,
    required String ramSize,
    required String screenResolution,
    required bool isRooted,
  }) async {
    return responseToResource(
      apiApp.addDevice(
        fcmToken: fcmToken,
        manufacturer: manufacturer,
        deviceModel: deviceModel,
        deviceOs: deviceOs,
        deviceOsVersion: deviceOsVersion,
        appVersion: appVersion,
        ramSize: ramSize,
        screenResolution: screenResolution,
        isRooted: isRooted,
      ),
    );
  }

  @override
  FutureOr<Resource<List<FaqResponse>?>> getFaq() async {
    return responseToResource(
      apiApp.getFaq(),
    );
  }

  @override
  FutureOr<Resource<StringResponse?>> contactUs({
    required String email,
    required String message,
  }) async {
    return responseToResource(
      apiApp.contactUs(email: email, message: message),
    );
  }

  @override
  FutureOr<Resource<DynamicPageResponse?>> getAboutUs() async {
    return responseToResource(
      apiApp.getAboutUs(),
    );
  }

  @override
  FutureOr<Resource<DynamicPageResponse?>> getTermsConditions() async {
    return responseToResource(
      apiApp.getTermsConditions(),
    );
  }

  @override
  FutureOr<Resource<List<ConfigurationResponseModel>?>>
      getConfigurations() async {
    return responseToResource(
      apiApp.getConfigurations(),
    );
  }

  @override
  FutureOr<Resource<List<CurrenciesResponseModel>?>> getCurrencies() async {
    return responseToResource(
      apiApp.getCurrencies(),
    );
  }

  @override
  FutureOr<Resource<List<BannerResponseModel>?>> getBanner() async {
    return responseToResource(
      apiApp.getBanner(),
    );
  }

  @override
  ValueStream<Resource<List<BannerResponseModel>?>> getBannerStream() {
    unawaited(_triggerBannerStream());
    return _bannersStream;
  }

  Future<void> _triggerBannerStream({bool forceReload = false}) async {
    if (!forceReload) {
      if (_bannersStream.currentValue != null &&
          _bannersStream.currentValue?.resourceType == ResourceType.success) {
        return;
      }
    }

    _bannersStream.add(Resource<List<BannerResponseModel>?>.loading());
    // _bannersStream.add(Resource<List<BannerResponseModel>?>.error(""));
    // return;
    if (forceReload) {
      locator<LocalStorageService>().remove(LocalStorageKeys.appBanner);
    } else {
      String? config = locator<LocalStorageService>().getString(
        LocalStorageKeys.appBanner,
      );

      List<BannerResponseModel>? configData;

      if (config != null) {
        try {
          configData = BannerResponseModel.fromJsonListString(config);
          _bannersStream.add(
            Resource<List<BannerResponseModel>?>.success(
              configData,
              message: "",
            ),
          );
          return;
        } on Object catch (e) {
          log(e.toString());
        }
      }
    }

    Resource<List<BannerResponseModel>?> response =
        await responseToResource<List<BannerResponseModel>?>(
      apiApp.getBanner(),
    );

    if (response.resourceType == ResourceType.success) {
      List<BannerResponseModel>? bannerData = response.data;

      locator<LocalStorageService>().setString(
        LocalStorageKeys.appBanner,
        BannerResponseModel.toJsonListString(
          bannerData ?? <BannerResponseModel>[],
        ),
      );
    }
    _bannersStream.add(response);
  }

  @override
  Future<void> resetBannerStream() {
   return _triggerBannerStream(forceReload: true);
  }
}
