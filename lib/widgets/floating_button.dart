import 'package:flutter/material.dart';

/// Nút nổi dùng trong app chính (preview)
class FloatingButtonPreview extends StatelessWidget {
  final VoidCallback? onTap;

  const FloatingButtonPreview({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.touch_app,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
