import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/app_apis/app_apis.dart";
import "package:esim_open_source/data/remote/responses/app/banner_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/dynamic_page_response.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/core/string_response.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/data/api_app.dart";
import "package:esim_open_source/domain/data/params/add_device_params.dart";

class APIAppImpl extends APIService implements APIApp {
  APIAppImpl._privateConstructor() : super.privateConstructor();

  static APIAppImpl? _instance;

  static APIAppImpl get instance {
    if (_instance == null) {
      _instance = APIAppImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<dynamic> addDevice(AddDeviceParams params) async {
    Map<String, dynamic> requestParams = <String, dynamic>{
      "fcm_token": params.fcmToken,
      "manufacturer": params.manufacturer,
      "device_model": params.deviceModel,
      "os": params.deviceOs,
      "os_version": params.deviceOsVersion,
      "app_version": params.appVersion,
      "ram_size": params.ramSize,
      "screen_resolution": params.screenResolution,
      "is_rooted": params.isRooted,
    };

    ResponseMain<EmptyResponse?> addDeviceResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.addDevice,
        parameters: requestParams,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return addDeviceResponse;
  }

  @override
  FutureOr<ResponseMain<List<FaqResponse>?>> getFaq() async {
    ResponseMain<List<FaqResponse>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.faq,
      ),
      fromJson: FaqResponse.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<StringResponse?>> contactUs({
    required String email,
    required String message,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "email": email,
      "content": message,
    };

    ResponseMain<StringResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.contactUs,
        parameters: params,
      ),
      fromJson: StringResponse.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<DynamicPageResponse?>> getAboutUs() async {
    ResponseMain<DynamicPageResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.aboutUS,
      ),
      fromJson: DynamicPageResponse.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<DynamicPageResponse?>> getTermsConditions() async {
    ResponseMain<DynamicPageResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.termsConditions,
      ),
      fromJson: DynamicPageResponse.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<List<ConfigurationResponseModel>?>>
      getConfigurations() async {
    ResponseMain<List<ConfigurationResponseModel>?> response =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.configurations,
      ),
      fromJson: ConfigurationResponseModel.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<List<CurrenciesResponseModel>?>> getCurrencies() async {
    ResponseMain<List<CurrenciesResponseModel>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.getCurrencies,
      ),
      fromJson: CurrenciesResponseModel.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<List<BannerResponseModel>?>> getBanner() async {
    Map<String, String> headers = <String, String>{
      "x-platform": "mobile",
    };

    ResponseMain<List<BannerResponseModel>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.getBanner,
        additionalHeaders: headers,
      ),
      fromJson: BannerResponseModel.fromJsonList,
    );

    return response;
  }
}
