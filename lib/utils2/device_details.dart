import 'dart:io';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:smat_crow/utils2/strings.dart';

class DeviceDetails {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        AppId = 'web-app-id';
        DeviceIp = '0.0.0.0';
        DeviceManufacturer = 'web-manufacturer';
        DeviceName = 'web-device';
        DeviceType = 'web';
        DeviceModel = 'web-model';
      } else if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        AppId = deviceData['androidId'];
        DeviceIp = deviceData['host'];
        DeviceManufacturer = deviceData['manufacturer'];
        DeviceName = deviceData['model'];
        DeviceType = deviceData['type'];
        DeviceModel = deviceData['model'];
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        AppId = deviceData['name'];
        DeviceIp = deviceData['systemVersion'];
        DeviceManufacturer = deviceData['identifierForVendor'];
        DeviceName = deviceData['utsname.sysname'];
        DeviceType = deviceData['localizedModel'];
        DeviceModel = deviceData['localizedModel'];
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
