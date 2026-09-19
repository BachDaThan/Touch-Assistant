import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../services/overlay_service.dart';
import '../services/accessibility_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _overlayEnabled = false;
  bool _accessibilityEnabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final acc = await AccessibilityHelper.isEnabled();
    final overlay = await FlutterOverlayWindow.isPermissionGranted();
    if (mounted) {
      setState(() {
        _accessibilityEnabled = acc;
        _overlayEnabled = overlay;
        _loading = false;
      });
    }
  }

  Future<void> _toggleOverlay(bool value) async {
    if (value) {
      if (!_accessibilityEnabled) {
        _showNeedAccessibility();
        return;
      }
      final ok = await OverlayService.requestOverlayPermission();
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cần cấp quyền "Hiển thị trên ứng dụng khác"')),
          );
        }
        return;
      }
      await OverlayService.startOverlay();
      setState(() => _overlayEnabled = true);
    } else {
      await OverlayService.stopOverlay();
      setState(() => _overlayEnabled = false);
    }
  }

  void _showNeedAccessibility() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cần quyền Accessibility'),
        content: const Text(
          'Để dùng Home / Back / Recents / Khóa màn hình / Chụp màn hình, '
          'bạn cần bật dịch vụ Accessibility cho app này.\n\n'
          'App chỉ dùng quyền này để thực hiện các lệnh bạn bấm, '
          'không đọc nội dung màn hình hay gửi dữ liệu đi đâu cả.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Để sau'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              AccessibilityHelper.openSettings();
            },
            child: const Text('Mở Cài đặt'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touch Assistant'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 56,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Assistive Touch miễn phí',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Hoàn toàn offline • Không quảng cáo • Không thu thập dữ liệu',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quyền Accessibility
                _PermissionTile(
                  icon: Icons.accessibility_new,
                  title: 'Dịch vụ Accessibility',
                  subtitle: _accessibilityEnabled
                      ? 'Đã bật ✓'
                      : 'Cần bật để dùng Home, Back, Recents, Khóa, Chụp màn hình',
                  enabled: _accessibilityEnabled,
                  onTap: () => AccessibilityHelper.openSettings(),
                ),
                const SizedBox(height: 12),

                // Overlay permission
                _PermissionTile(
                  icon: Icons.layers,
                  title: 'Hiển thị trên ứng dụng khác',
                  subtitle: _overlayEnabled
                      ? 'Đã cấp ✓'
                      : 'Cần cấp để hiện nút nổi',
                  enabled: _overlayEnabled,
                  onTap: () => OverlayService.requestOverlayPermission()
                      .then((_) => _checkPermissions()),
                ),
                const SizedBox(height: 24),

                // Toggle nút nổi
                Card(
                  child: SwitchListTile(
                    title: const Text(
                      'Bật nút nổi Assistive Touch',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _overlayEnabled
                          ? 'Nút nổi đang chạy. Kéo thả để di chuyển.'
                          : 'Bật để hiện nút nổi trên mọi màn hình',
                    ),
                    value: _overlayEnabled,
                    onChanged: _toggleOverlay,
                  ),
                ),
                const SizedBox(height: 24),

                // Hướng dẫn
                Text(
                  'Chức năng menu',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                const _FeatureRow(Icons.home, 'Home', 'Về màn hình chính'),
                const _FeatureRow(Icons.arrow_back, 'Back', 'Quay lại'),
                const _FeatureRow(Icons.apps, 'Recents', 'Ứng dụng gần đây'),
                const _FeatureRow(Icons.lock, 'Khóa', 'Khóa màn hình'),
                const _FeatureRow(Icons.screenshot, 'Chụp', 'Chụp màn hình'),
                const _FeatureRow(Icons.volume_up, 'Volume', 'Tăng / Giảm âm lượng'),
                const SizedBox(height: 32),

                // Privacy
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.security, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Bảo mật & Riêng tư',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Không gửi dữ liệu lên server\n'
                        '• Không quảng cáo, không theo dõi\n'
                        '• Chỉ dùng quyền Accessibility để thực hiện lệnh bạn chọn\n'
                        '• Mã nguồn mở, hoàn toàn miễn phí',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: enabled
              ? Colors.green.withOpacity(0.15)
              : Colors.orange.withOpacity(0.15),
          child: Icon(
            icon,
            color: enabled ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: enabled
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureRow(this.icon, this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              desc,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
