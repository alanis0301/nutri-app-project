import 'package:flutter/material.dart';
import 'info_chip.dart';

class RecipeInformation extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeInformation({super.key, required this.recipe});

  @override
  State<RecipeInformation> createState() => _RecipeInformationState();
}

class _RecipeInformationState extends State<RecipeInformation> {
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
            recipe['name'],
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            recipe['description'],
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
                label: '${(recipe['prepTime'] as num).round()} min',
              ),
              InfoChip(
                icon: Icons.star_border,
                label: recipe['difficulty'] ?? '-',
              ),
              InfoChip(
                icon: Icons.local_fire_department,
                label: '${recipe['calories'] ?? '-'} kcal',
              ),
              InfoChip(
                icon: Icons.fitness_center,
                label: '${((recipe['protein'] as num?) ?? 0).round()}g proteína',
              ),
            ],
          ),
        ],
      ),
    );
  }
}