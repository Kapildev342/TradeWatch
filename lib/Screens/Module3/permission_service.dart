import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future requestPhotosPermission();

  Future<bool> handlePhotosPermission(BuildContext context);

  Future requestCameraPermission();

  Future<bool> handleCameraPermission(BuildContext context);

  Future requestStoragePermission();
}

class PermissionHandlerPermissionService extends PermissionService {
  @override
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  @override
  Future<PermissionStatus> requestPhotosPermission() async {
    return await Permission.photos.request();
  }

  @override
  Future<PermissionStatus> requestStoragePermission() async {
    return await Permission.storage.request();
  }

  @override
  Future<bool> handleCameraPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await requestCameraPermission();
    if (cameraPermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> handlePhotosPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        /// use [Permissions.storage.status]
        PermissionStatus storagePermissionStatus = await requestStoragePermission();
        if (storagePermissionStatus == PermissionStatus.granted) {
          return true;
        } else {
          if (storagePermissionStatus == PermissionStatus.denied) {}
          return false;
        }
      } else {
        /// use [Permissions.photos.status]
        PermissionStatus photosPermissionStatus = await requestPhotosPermission();
        if (photosPermissionStatus == PermissionStatus.granted) {
          return true;
        } else {
          if (photosPermissionStatus == PermissionStatus.denied) {}
        }
        return false;
      }
    } else {
      return false;
    }
  }
}
