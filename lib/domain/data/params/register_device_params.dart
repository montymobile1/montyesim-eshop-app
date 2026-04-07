import "package:esim_open_source/data/remote/request/device/device_info_request_model.dart";

class RegisterDeviceParams {
  RegisterDeviceParams({
    required this.fcmToken,
    required this.deviceId,
    required this.platformTag,
    required this.osTag,
    required this.appGuid,
    required this.version,
    required this.userGuid,
    required this.deviceInfo,
  });

  String fcmToken;
  String deviceId;
  String platformTag;
  String osTag;
  String appGuid;
  String version;
  String userGuid;
  DeviceInfoRequestModel deviceInfo;
}
