import "dart:async";

import "package:esim_open_source/domain/data/params/add_device_params.dart";

abstract interface class ApiAppRepository {
  FutureOr<dynamic> addDevice(AddDeviceParams params);

  FutureOr<dynamic> getFaq();

  FutureOr<dynamic> contactUs({
    required String email,
    required String message,
  });

  FutureOr<dynamic> getAboutUs();

  FutureOr<dynamic> getTermsConditions();

  FutureOr<dynamic> getConfigurations();

  FutureOr<dynamic> getCurrencies();

  FutureOr<dynamic> getBanner();

  dynamic getBannerStream();

  Future<void> resetBannerStream();
}
