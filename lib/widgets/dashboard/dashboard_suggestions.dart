import 'package:flutter/material.dart';
import 'package:nutri_app_project/widgets/dashboard/cards/recipe_card.dart';

/// Sugestões do backend (RF11): sem restrições do usuário, priorizando preferências e objetivo.
class DashboardSuggestions extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;
  final ValueChanged<Map<String, dynamic>> onTap;

  const DashboardSuggestions({
    super.key,
    required this.recipes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sugestões para você',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 10),
        if (recipes.isEmpty)
          const Text(
            'Nenhuma receita compatível com suas restrições.',
            style: TextStyle(fontSize: 13, color: Color(0xFF697386)),
          )
        else
          Row(
            children: [
              for (var i = 0; i < recipes.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(recipes[i]),
                    child: RecipeCard(
                      imageUrl: recipes[i]['imageUrl'] ?? '',
                      title: recipes[i]['name'],
                      time: '${(recipes[i]['prepTime'] as num).round()} min',
                      calories: '${recipes[i]['calories'] ?? '-'} kcal',
                    ),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}
