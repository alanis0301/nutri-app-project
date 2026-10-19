import 'package:flutter/material.dart';
import 'info_chip.dart';

class RecipeInformation extends StatefulWidget {
  final Map<String, dynamic>? recipe;

  const RecipeInformation({super.key, this.recipe});

  @override
  State<RecipeInformation> createState() => _RecipeInformationState();
}

class _RecipeInformationState extends State<RecipeInformation> {
  // 1. Declaração da variável de estado aqui
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    const Color textColor = Color(0xFF171E2E);
    const Color secondaryText = Color(0xFF687184);
    final recipe = widget.recipe;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe?['name'] ?? 'Salmão ao forno com batata-doce e brócolis',
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            recipe?['description'] ?? 'por Cozinha NutriViver',
            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          // Informações em etiquetas
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(
                icon: Icons.access_time_filled,
                label: recipe != null
                    ? '${(recipe['prepTime'] as num).round()} min'
                    : '30 min',
              ),
              InfoChip(
                icon: Icons.star_border,
                label: recipe?['difficulty'] ?? 'Fácil',
              ),
              InfoChip(
                icon: Icons.local_fire_department,
                label: '420 kcal',
              ),
              InfoChip(
                icon: Icons.fitness_center,
                label: '35g proteína',
              ),
            ],
          ),
        ],
      ),
    );
  }
}