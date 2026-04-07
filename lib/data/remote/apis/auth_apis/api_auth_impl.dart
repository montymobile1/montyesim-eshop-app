import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/auth_apis/auth_apis.dart";
import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/http_request.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/auth/otp_response_model.dart";
import "package:esim_open_source/data/remote/responses/auth/resend_otp_response_model.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/data/api_auth.dart";
import "package:esim_open_source/domain/data/params/update_user_info_params.dart";

class APIAuthImpl extends APIService implements APIAuth {
  APIAuthImpl._privateConstructor() : super.privateConstructor();

  static APIAuthImpl? _instance;

  static APIAuthImpl get instance {
    if (_instance == null) {
      _instance = APIAuthImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMain<OtpResponseModel?>> login({
    required String? email,
    required String? phoneNumber,
    String? otpChannel,
  }) async {
    Map<String, String> params = <String, String>{
      if (email != null) "email": email,
      if (phoneNumber != null) "phone": phoneNumber,
      if (otpChannel != null) "otp_channel": otpChannel,
    };

    ResponseMain<OtpResponseModel?> loginResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.login,
        parameters: params,
      ),
      fromJson: OtpResponseModel.fromJson,
    );

    return loginResponse;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse>> logout() async {
    ResponseMain<EmptyResponse> emptyResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.logout,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return emptyResponse;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> resendOtp({
    required String email,
  }) async {
    Map<String, String> params = <String, String>{
      "email": email,
    };

    ResponseMain<EmptyResponse?> resendOtpResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.resendOtp,
        parameters: params,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return resendOtpResponse;
  }

  @override
  FutureOr<ResponseMain<ResendOtpResponseModel?>> resendOtpNewChannel({
    required String? email,
    required String? phone,
    required String otpChannel,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      "otp_channel": otpChannel,
    };

    ResponseMain<ResendOtpResponseModel?> resendOtpResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.resendOtpNewChannel,
        parameters: params,
      ),
      fromJson: ResendOtpResponseModel.fromJson,
    );

    return resendOtpResponse;
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel>> verifyOtp({
    String? email,
    String? phoneNumber,
    String pinCode = "",
    String providerToken = "",
    String providerType = "",
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      if (email != null) "user_email": email,
      if (phoneNumber != null) "phone": phoneNumber,
      "verification_pin": pinCode,
      "provider_token": providerToken,
      "provider_type": providerType,
    };

    ResponseMain<AuthResponseModel> authResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.verifyOtp,
        parameters: params,
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return authResponse;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse>> deleteAccount() async {
    ResponseMain<EmptyResponse> emptyResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.deleteAccount,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return emptyResponse;
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel>> updateUserInfo({
    required UpdateUserInfoRequest request,
  }) async {
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer ${request.bearerToken}",
    };

    Map<String, dynamic> params = <String, dynamic>{
      if (request.email != null) "email": request.email,
      if (request.msisdn != null) "msisdn": request.msisdn,
      if (request.firstName != null) "first_name": request.firstName,
      if (request.lastName != null) "last_name": request.lastName,
      if (request.currencyCode != null) "currency": request.currencyCode, //?? getSelectedCurrencyCode(),
      if (request.languageCode != null) "language": request.languageCode , //?? LanguageEnum.fromCode(locator<LocalStorageService>().languageCode).languageText,
    };

    ResponseMain<AuthResponseModel> authResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        parameters: params,
        endPoint: AuthApis.updateUserInfo,
        additionalHeaders:
            (request.bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return authResponse;
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel>> getUserInfo({
    String? bearerToken,
  }) async {
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $bearerToken",
    };

    ResponseMain<AuthResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.userInfo,
        additionalHeaders:
            (bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return response;
  }

  @override
  FutureOr<dynamic> refreshTokenAPITrigger() async {
    return refreshTokenAPI();
  }

  @override
  void addUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    HttpRequest.addUnauthorizedAccessCallBackListener(
      unauthorizedAccessCallBack,
    );
  }

  @override
  void removeUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    HttpRequest.removeUnauthorizedAccessCallBackListener(
      unauthorizedAccessCallBack,
    );
  }

  @override
  void addAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  ) {
    HttpRequest.addAuthReloadListenerCallBack(
      authReloadListener,
    );
  }

  @override
  void removeAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  ) {
    HttpRequest.removeAuthReloadListenerCallBack(
      authReloadListener,
    );
  }

  @override
  FutureOr<ResponseMain<AuthResponseModel?>> tmpLogin({
    required String? email,
    required String? phone,
  }) async {
    Map<String, String> params = <String, String>{
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
    };

    ResponseMain<AuthResponseModel?> tmpLoginResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.tmpLogin,
        parameters: params,
      ),
      fromJson: AuthResponseModel.fromAPIJson,
    );

    return tmpLoginResponse;
  }
}
