import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/device_apis/device_apis.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model.dart";
import "package:esim_open_source/domain/data/api_device.dart";
import "package:esim_open_source/domain/data/params/register_device_params.dart";

class ApiDeviceImpl extends APIService implements APIDevice {
  ApiDeviceImpl._privateConstructor() : super.privateConstructor();

  static ApiDeviceImpl? _instance;

  static ApiDeviceImpl get instance {
    if (_instance == null) {
      _instance = ApiDeviceImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMain<DeviceInfoResponseModel?>> registerDevice({
required RegisterDeviceParams params,
  }) async {
    Map<String, dynamic> requestParams = <String, dynamic>{
      "deviceId": params.deviceId,
      "fcmToken": params.fcmToken,
      "platformTag": params.platformTag,
      "osTag": params.osTag,
      "appGuid": params.appGuid,
      "Version": params.version,
      "deviceInfo": params.deviceInfo.toJson(),
    };

    if (params.userGuid.isNotEmpty) {
      requestParams["userGuid"] = params.userGuid;
    }

    ResponseMain<DeviceInfoResponseModel?> registerDeviceResponse =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: DeviceApis.registerDevice,
        parameters: requestParams,
      ),
      fromJson: DeviceInfoResponseModel.fromJson,
    );

    return registerDeviceResponse;
  }
}
