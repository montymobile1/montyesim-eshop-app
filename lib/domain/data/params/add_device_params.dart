class AddDeviceParams {
  AddDeviceParams({
    required this.fcmToken,
    required this.manufacturer,
    required this.deviceModel,
    required this.deviceOs,
    required this.deviceOsVersion,
    required this.appVersion,
    required this.ramSize,
    required this.screenResolution,
    required this.isRooted,
  });

  String fcmToken;
  final String manufacturer;
  final String deviceModel;
  final String deviceOs;
  final String deviceOsVersion;
  String appVersion;
  final String ramSize;
  final String screenResolution;
  bool isRooted;
}
