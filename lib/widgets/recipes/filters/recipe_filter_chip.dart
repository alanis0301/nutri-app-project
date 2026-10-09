import 'package:flutter/material.dart';
import 'package:nutri_app_project/pages/filter_recipes_page.dart';

class RecipeFilterChip extends StatelessWidget {
  final String label;

  const RecipeFilterChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RecipeFiltersPage(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE1E5EB),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF697386),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
