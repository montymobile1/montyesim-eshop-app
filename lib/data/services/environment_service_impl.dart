import "dart:io";

import "package:esim_open_source/domain/repository/services/environment_service.dart";

class EnvironmentServiceImpl implements EnvironmentService {
  EnvironmentServiceImpl._privateConstructor();

  static EnvironmentServiceImpl? _instance;

  static EnvironmentServiceImpl get instance {
    _instance ??= EnvironmentServiceImpl._privateConstructor();
    return _instance!;
  }

  @override
  bool get isAndroid => Platform.isAndroid;
}
