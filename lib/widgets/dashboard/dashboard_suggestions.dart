import 'package:flutter/material.dart';
import 'package:nutri_app_project/widgets/dashboard/cards/recipe_card.dart';

class DashboardSuggestions extends StatelessWidget {
  const DashboardSuggestions({super.key});

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
        Row(
          children: [
            Expanded(
              child: const RecipeCard(
                imageUrl: 'https://images.unsplash.com/'
                    'photo-1512621776951-a57141f2eefd'
                    '?auto=format&fit=crop&w=500&q=80',
                title: 'Bowl de Açaí Proteico',
                time: '10 min',
                calories: '320 kcal',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: const RecipeCard(
                imageUrl: 'https://images.unsplash.com/'
                    'photo-1626700051175-6818013e1d4f'
                    '?auto=format&fit=crop&w=500&q=80',
                title: 'Wrap Integral de Atum',
                time: '12 min',
                calories: '280 kcal',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
