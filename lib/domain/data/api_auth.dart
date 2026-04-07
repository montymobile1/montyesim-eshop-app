import "dart:async";

import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/domain/data/params/update_user_info_params.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";

abstract interface class APIAuth {
  FutureOr<dynamic> login({
    required String? email,
    required String? phoneNumber,
    String? otpChannel,
  });

  FutureOr<dynamic> resendOtp({
    required String email,
  });

  FutureOr<dynamic> resendOtpNewChannel({
    required String? email,
    required String? phone,
    required String otpChannel,
  });

  FutureOr<dynamic> logout();

  FutureOr<dynamic> verifyOtp({
    String? email,
    String? phoneNumber,
    String pinCode = "",
    String providerToken = "",
    String providerType = "",
  });

  FutureOr<dynamic> deleteAccount();

  FutureOr<dynamic> updateUserInfo({
    required UpdateUserInfoRequest request,
  });

  FutureOr<dynamic> getUserInfo({
    String? bearerToken,
  });

  FutureOr<dynamic> refreshTokenAPITrigger();

  void addUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  );

  void removeUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  );

  void addAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  );

  void removeAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  );

  FutureOr<dynamic> tmpLogin({
    required String? email,
    required String? phone,
  });
}
