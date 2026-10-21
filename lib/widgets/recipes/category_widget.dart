import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String label;
  final Widget iconWidget;
  final bool selected;

  const CategoryWidget({
    super.key,
    required this.label,
    required this.iconWidget,
    this.selected = false,
  });

  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07863D);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF0FBF4) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? green : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? darkGreen : const Color(0xFF1A1C1E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (selected) const Icon(Icons.check_circle, size: 18, color: green),
        ],
      ),
    );
  }
}
