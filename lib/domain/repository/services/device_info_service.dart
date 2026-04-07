import "package:device_info_plus/device_info_plus.dart";
import "package:esim_open_source/domain/data/params/add_device_params.dart";

abstract class DeviceInfoService {
  Future<String> get deviceID;
  Future<DeviceInfoPlugin> get deviceInfoPlugin;
  Future<Map<String, dynamic>> get deviceData;
  Future<AddDeviceParams> get addDeviceParams;
  Future<bool> get isRooted;
  Future<bool> get isPhysicalDevice;
  Future<bool> get isDevelopmentModeEnable;
}
