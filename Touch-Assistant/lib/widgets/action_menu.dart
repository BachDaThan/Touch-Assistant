import 'package:flutter/material.dart';

class ActionMenu extends StatelessWidget {
  final Future<void> Function(String) onAction;

  const ActionMenu({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(Icons.home, 'Home', 'home', Colors.blue),
      _ActionItem(Icons.arrow_back, 'Back', 'back', Colors.orange),
      _ActionItem(Icons.apps, 'Recents', 'recents', Colors.purple),
      _ActionItem(Icons.lock, 'Khóa', 'lock', Colors.red),
      _ActionItem(Icons.screenshot, 'Chụp', 'screenshot', Colors.teal),
      _ActionItem(Icons.volume_up, 'Vol+', 'vol_up', Colors.green),
      _ActionItem(Icons.volume_down, 'Vol-', 'vol_down', Colors.green),
    ];

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withOpacity(0.95),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 220),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actions.map((a) {
            return InkWell(
              onTap: () => onAction(a.key),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: a.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(a.icon, color: a.color, size: 24),
                    const SizedBox(height: 2),
                    Text(
                      a.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: a.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String key;
  final Color color;

  _ActionItem(this.icon, this.label, this.key, this.color);
}
