import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_accessibility_service/constants.dart';
import 'package:volume_controller/volume_controller.dart';

class AccessibilityHelper {
  /// Kiểm tra quyền Accessibility đã bật chưa
  static Future<bool> isEnabled() async {
    try {
      return await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
    } catch (_) {
      return false;
    }
  }

  /// Mở trang cài đặt Accessibility
  static Future<void> openSettings() async {
    await FlutterAccessibilityService.requestAccessibilityPermission();
  }

  static Future<bool> perform(GlobalAction action) async {
    try {
      return await FlutterAccessibilityService.performGlobalAction(action);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> goHome() => perform(GlobalAction.globalActionHome);
  static Future<bool> goBack() => perform(GlobalAction.globalActionBack);
  static Future<bool> openRecents() => perform(GlobalAction.globalActionRecents);
  static Future<bool> lockScreen() =>
      perform(GlobalAction.globalActionLockScreen);
  static Future<bool> takeScreenshot() =>
      perform(GlobalAction.globalActionTakeScreenshot);

  /// Volume (setVolume không trả Future trên bản 2.x)
  static Future<void> volumeUp() async {
    try {
      final current = await VolumeController().getVolume();
      VolumeController().setVolume((current + 0.1).clamp(0.0, 1.0));
    } catch (_) {}
  }

  static Future<void> volumeDown() async {
    try {
      final current = await VolumeController().getVolume();
      VolumeController().setVolume((current - 0.1).clamp(0.0, 1.0));
    } catch (_) {}
  }
}
