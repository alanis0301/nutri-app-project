import 'package:flutter/material.dart';
import 'ingredients_list.dart';
import 'preparation_list.dart';

class TabContent extends StatelessWidget {
  final int selectedTab;
  final Map<String, dynamic>? recipe;

  const TabContent({
    super.key,
    required this.selectedTab,
    this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    const Color dividerColor = Color(0xFFE0E4E9);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
          if (selectedTab == 0)
            IngredientsList(
              items: (recipe?['ingredients'] as List?)?.map((i) {
                final qty = i['quantity'] as num;
                final amount = qty == qty.roundToDouble() ? qty.round() : qty;
                return '$amount ${i['measureUnity']} de ${i['ingredient']['name']}';
              }).toList(),
            )
          else
            PreparationList(
              steps: (recipe?['steps'] as List?)?.cast<String>(),
            ),
        ],
      ),
    );
  }
}
