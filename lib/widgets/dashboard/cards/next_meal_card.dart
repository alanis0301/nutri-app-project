import 'package:flutter/material.dart';
import 'package:nutri_app_project/widgets/dashboard/meal_tag.dart';

/// Próxima refeição pendente do dia (vinda do cardápio).
class NextMealHeader extends StatelessWidget {
  final Map<String, dynamic>? meal;
  final ValueChanged<Map<String, dynamic>> onTap;
  final VoidCallback onPlanMeal;

  const NextMealHeader({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onPlanMeal,
  });

  @override
  Widget build(BuildContext context) {
    final recipe = meal?['recipe'] as Map<String, dynamic>?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Próxima refeição',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172033),
              ),
            ),
            if (meal != null)
              Text(
                'Hoje às ${meal!['time']}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF16C768),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (meal == null)
          InkWell(
            onTap: onPlanMeal,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FBF4),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: const [
                  Icon(Icons.event_available, color: Color(0xFF07863D)),
                  SizedBox(height: 8),
                  Text(
                    'Nenhuma refeição pendente hoje.\nToque para planejar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF07863D), fontSize: 13),
                  ),
                ],
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () => onTap(recipe),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 158,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      recipe!['imageUrl'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFE8F8EE)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.70),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MealTag(text: meal!['mealType']),
                              const SizedBox(width: 8),
                              MealTag(text: '${(recipe['prepTime'] as num).round()} min'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recipe['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
