import 'package:flutter/material.dart';

class IngredientSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const IngredientSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  static const Color verde = Color(0xFF20C663);
  static const Color borda = Color(0xFFE1E5EB);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Buscar ingrediente...',
        hintStyle: const TextStyle(
          color: Color(0xFF858B98),
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF737B8C),
          size: 21,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: verde,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}
