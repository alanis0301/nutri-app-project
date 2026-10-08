import 'package:flutter/material.dart';

class SearchRecipes extends StatelessWidget {
  const SearchRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
      hintText: 'Buscar receitas, ingredientes...',
      hintStyle: const TextStyle(
        color: Color(0xFF9EA5B1),
        fontSize: 14,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Color(0xFF9EA5B1),
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE1E5EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF16C768),
        ),
      ),
    ));
  }
}
