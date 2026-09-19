import 'package:flutter/services.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_accessibility_service/accessibility_event.dart';
import 'package:volume_controller/volume_controller.dart';

class AccessibilityHelper {
  static const MethodChannel _channel =
      MethodChannel('com.bachdathan.touch_assistant/actions');

  /// Kiểm tra quyền Accessibility đã bật chưa
  static Future<bool> isEnabled() async {
    try {
      return await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
    } catch (_) {
      return false;
    }
  }

  /// Mở trang cài đặt Accessibility để user bật service
  static Future<void> openSettings() async {
    await FlutterAccessibilityService.requestAccessibilityPermission();
  }

  /// Thực hiện action hệ thống
  static Future<bool> perform(GlobalAction action) async {
    try {
      return await FlutterAccessibilityService.performGlobalAction(action);
    } catch (e) {
      // Fallback native channel nếu plugin fail
      try {
        final result = await _channel.invokeMethod<bool>('performAction', {
          'action': action.index,
        });
        return result ?? false;
      } catch (_) {
        return false;
      }
    }
  }

  static Future<bool> goHome() => perform(GlobalAction.globalActionHome);
  static Future<bool> goBack() => perform(GlobalAction.globalActionBack);
  static Future<bool> openRecents() => perform(GlobalAction.globalActionRecents);
  static Future<bool> lockScreen() => perform(GlobalAction.globalActionLockScreen);
  static Future<bool> takeScreenshot() =>
      perform(GlobalAction.globalActionTakeScreenshot);

  /// Volume control (không cần Accessibility)
  static Future<void> volumeUp() async {
    final current = await VolumeController().getVolume();
    await VolumeController().setVolume((current + 0.1).clamp(0.0, 1.0));
  }

  static Future<void> volumeDown() async {
    final current = await VolumeController().getVolume();
    await VolumeController().setVolume((current - 0.1).clamp(0.0, 1.0));
  }
}
