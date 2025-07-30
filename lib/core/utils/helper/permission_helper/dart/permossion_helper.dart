import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Ensures storage permission is granted before accessing files
  static Future<bool> ensureStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        final sdkInt = await _getAndroidSdkInt();

        if (sdkInt >= 30) {
          // Android 11+ requires MANAGE_EXTERNAL_STORAGE
          final status = await Permission.manageExternalStorage.status;

          if (status.isGranted) return true;

          if (status.isPermanentlyDenied) {
            await openAppSettings();
            return false;
          }

          final result = await Permission.manageExternalStorage.request();
          return result.isGranted;
        } else {
          // Android 10 and below
          final status = await Permission.storage.status;

          if (status.isGranted) return true;

          if (status.isPermanentlyDenied) {
            await openAppSettings();
            return false;
          }

          final result = await Permission.storage.request();
          return result.isGranted;
        }
      }

      // iOS or desktop — allow
      return true;
    } catch (e, stacktrace) {
      print('❌ Permission error: $e');
      print(stacktrace);
      return false;
    }
  }

  /// Check if storage permission is granted without requesting
  static Future<bool> isStoragePermissionGranted() async {
    try {
      if (Platform.isAndroid) {
        final sdkInt = await _getAndroidSdkInt();

        if (sdkInt >= 30) {
          return await Permission.manageExternalStorage.isGranted;
        } else {
          return await Permission.storage.isGranted;
        }
      }

      return true;
    } catch (e, stacktrace) {
      print('❌ Error checking storage permission: $e');
      print(stacktrace);
      return false;
    }
  }

  /// Opens settings if permission is permanently denied
  static Future<void> openSettingsIfNeeded() async {
    try {
      if (Platform.isAndroid) {
        final sdkInt = await _getAndroidSdkInt();
        final perm = sdkInt >= 30
            ? Permission.manageExternalStorage
            : Permission.storage;

        if (await perm.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    } catch (e, stacktrace) {
      print('❌ Failed to open app settings: $e');
      print(stacktrace);
    }
  }

  static Future<int> _getAndroidSdkInt() async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    } catch (e) {
      return 0;
    }
  }
}
