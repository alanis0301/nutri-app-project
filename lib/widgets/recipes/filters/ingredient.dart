import 'package:flutter/material.dart';

class Ingredient extends StatelessWidget {
  final List<String> ingredients;
  final Set<String> selectedIngredients;
  final ValueChanged<String> onIngredientTap;

  const Ingredient({
    super.key,
    required this.ingredients,
    required this.selectedIngredients,
    required this.onIngredientTap,
  });

  static const Color verde = Color(0xFF20C663);
  static const Color borda = Color(0xFFE1E5EB);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ingredients.map((ingredient) {
        final isSelected = selectedIngredients.contains(ingredient);

        return InkWell(
          onTap: () => onIngredientTap(ingredient),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F8EE) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? verde : borda,
              ),
            ),
            child: Text(
              ingredient,
              style: TextStyle(
                color: isSelected ? verde : const Color(0xFF697386),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
