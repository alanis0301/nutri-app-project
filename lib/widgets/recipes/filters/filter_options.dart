import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  final List<String> options;
  final Set<String> selection;
  final ValueChanged<String> onOptionTap;

  const FilterOptions({
    super.key,
    required this.options,
    required this.selection,
    required this.onOptionTap,
  });

  static const Color verde = Color(0xFF20C663);
  static const Color borda = Color(0xFFE1E5EB);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final selected = selection.contains(option);

        return InkWell(
          onTap: () => onOptionTap(option),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFE8F8EE) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? verde : borda,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: selected ? verde : const Color(0xFF697386),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
