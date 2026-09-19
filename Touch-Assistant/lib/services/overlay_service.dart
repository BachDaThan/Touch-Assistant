import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/floating_button.dart';
import '../widgets/action_menu.dart';
import 'accessibility_helper.dart';

class OverlayService {
  static bool _isMenuOpen = false;

  /// Kiểm tra + xin quyền Overlay
  static Future<bool> requestOverlayPermission() async {
    final status = await FlutterOverlayWindow.isPermissionGranted();
    if (status) return true;
    return await FlutterOverlayWindow.requestPermission() ?? false;
  }

  /// Bật nút nổi
  static Future<void> startOverlay() async {
    final hasPermission = await requestOverlayPermission();
    if (!hasPermission) return;

    if (await FlutterOverlayWindow.isActive()) return;

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      height: 80,
      width: 80,
      alignment: OverlayAlignment.centerRight,
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilitySecret,
      overlayTitle: "Touch Assistant",
      overlayContent: "Assistive Touch đang chạy",
    );
  }

  /// Tắt nút nổi
  static Future<void> stopOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  /// Nội dung hiển thị trong overlay (được gọi từ overlayMain)
  static Widget buildOverlayContent() {
    return const FloatingButtonOverlay();
  }
}

/// Widget chạy bên trong Overlay window
class FloatingButtonOverlay extends StatefulWidget {
  const FloatingButtonOverlay({super.key});

  @override
  State<FloatingButtonOverlay> createState() => _FloatingButtonOverlayState();
}

class _FloatingButtonOverlayState extends State<FloatingButtonOverlay> {
  bool _menuOpen = false;

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
  }

  Future<void> _onAction(String action) async {
    setState(() => _menuOpen = false);

    switch (action) {
      case 'home':
        await AccessibilityHelper.goHome();
        break;
      case 'back':
        await AccessibilityHelper.goBack();
        break;
      case 'recents':
        await AccessibilityHelper.openRecents();
        break;
      case 'lock':
        await AccessibilityHelper.lockScreen();
        break;
      case 'screenshot':
        await AccessibilityHelper.takeScreenshot();
        break;
      case 'vol_up':
        await AccessibilityHelper.volumeUp();
        break;
      case 'vol_down':
        await AccessibilityHelper.volumeDown();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Nút nổi chính
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _menuOpen
                      ? Colors.blue.shade700
                      : Colors.black.withOpacity(0.75),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _menuOpen ? Icons.close : Icons.touch_app,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          // Menu actions
          if (_menuOpen)
            Positioned(
              right: 70,
              top: 0,
              child: ActionMenu(onAction: _onAction),
            ),
        ],
      ),
    );
  }
}
