import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum AuthApis implements URlRequestBuilder {
  login,
  tmpLogin,
  logout,
  resendOtp,
  resendOtpNewChannel,
  verifyOtp,
  refreshToken,
  deleteAccount,
  userInfo,
  updateUserInfo;

  @override
  String get baseURL => "";

  @override
  String get path {
    switch (this) {
      case AuthApis.login:
        return "/api/v1/auth/login";
      case AuthApis.logout:
        return "/api/v1/auth/logout";
      case AuthApis.resendOtp:
        return "/api/v1/auth/login";
      case AuthApis.resendOtpNewChannel:
        return "/api/v1/auth/resend-otp";
      case AuthApis.verifyOtp:
        return "/api/v1/auth/verify_otp";
      case AuthApis.refreshToken:
        return "/api/v1/auth/refresh-token";
      case AuthApis.deleteAccount:
        return "/api/v1/auth/delete-account";
      case AuthApis.updateUserInfo:
        return "/api/v1/auth/user-info";
      case AuthApis.userInfo:
        return "/api/v1/auth/user-info";
      case AuthApis.tmpLogin:
        return "/api/v1/auth/tmp-login";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case AuthApis.deleteAccount:
        return HttpMethod.DELETE;
      case AuthApis.userInfo:
        return HttpMethod.GET;
      default:
        return HttpMethod.POST;
    }
  }

  @override
  bool get hasAuthorization {
    switch (this) {
      case AuthApis.logout:
      case AuthApis.deleteAccount:
      case AuthApis.updateUserInfo:
      case AuthApis.userInfo:
        return true;
      default:
        return false;
    }
  }

  @override
  bool get isRefreshToken {
    switch (this) {
      case AuthApis.refreshToken:
        return true;
      default:
        return false;
    }
  }

  @override
  Map<String, String> get headers {
    switch (this) {
      case AuthApis.resendOtpNewChannel:
        return <String, String>{
          "accept-language": "en",
        };
      default:
        return const <String, String>{};
    }
  }
}
