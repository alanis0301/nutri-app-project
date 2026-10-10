import 'package:flutter/material.dart';
import 'ingredients_list.dart';
import 'preparation_list.dart';

class TabContent extends StatelessWidget {
  final int selectedTab;

  const TabContent({
    super.key,
    required this.selectedTab,
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
            const IngredientsList()
          else
            const PreparationList(),
        ],
      ),
    );
  }
}
