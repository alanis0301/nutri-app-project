import 'package:flutter/material.dart';

class ActiveFilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color greenColor;
  final VoidCallback onTap;

  const ActiveFilterChip({
    super.key,
    required this.icon,
    required this.label,
    required this.greenColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: greenColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: greenColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: greenColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: greenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
