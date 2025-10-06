import "dart:async";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/extensions/navigation_service_extensions.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";

class ProfileViewModel extends BaseModel {
  String _appVersion = "";

  String get appVersion => _appVersion;
  String _buildNumber = "";

  String get buildNumber => _buildNumber;

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPackageInfo();
      notifyListeners();
    });
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _appVersion = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  Future<void> loginButtonTapped() async {
    navigationService.navigateToLoginScreen();
  }

  String getUserName() {
    if (AppEnvironment.appEnvironmentHelper.loginType ==
            LoginType.phoneNumber ||
        AppEnvironment.appEnvironmentHelper.loginType ==
            LoginType.emailAndPhone) {
      return userMsisdn;
    }
    return userEmailAddress;
  }
}
