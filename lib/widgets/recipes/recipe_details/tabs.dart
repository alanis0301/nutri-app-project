import 'package:flutter/material.dart';
import 'build_tab.dart';

class Tabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const Tabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: BuildTab(
              label: 'Ingredientes',
              index: 0,
              selectedIndex: selectedTab,
              onTap: onTabChanged,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: BuildTab(
              label: 'Modo de preparo',
              index: 1,
              selectedIndex: selectedTab,
              onTap: onTabChanged,
            ),
          ),
        ],
      ),
    );
  }
}
