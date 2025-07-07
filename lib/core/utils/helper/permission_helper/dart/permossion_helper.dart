import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Ensures storage permission is granted before accessing files
  static Future<bool> ensureStoragePermission() async {
    try {
      final status = await Permission.storage.status;

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      final result = await Permission.storage.request();
      return result.isGranted;
    } catch (e, stacktrace) {
      print('❌ Permission error: $e');
      print(stacktrace);
      return false;
    }
  }

  /// Optional: Check if permission is granted without requesting
  static Future<bool> isStoragePermissionGranted() async {
    try {
      return await Permission.storage.isGranted;
    } catch (e, stacktrace) {
      print('❌ Error checking storage permission: $e');
      print(stacktrace);
      return false;
    }
  }

  /// Optional: Open settings if permission is permanently denied
  static Future<void> openSettingsIfNeeded() async {
    try {
      if (await Permission.storage.isPermanentlyDenied) {
        await openAppSettings();
      }
    } catch (e, stacktrace) {
      print('❌ Failed to open app settings: $e');
      print(stacktrace);
    }
  }
}
