import "dart:async";

import "package:esim_open_source/domain/data/params/register_device_params.dart";

abstract interface class APIDevice {
  FutureOr<dynamic> registerDevice({
    required RegisterDeviceParams params,
  });
}
