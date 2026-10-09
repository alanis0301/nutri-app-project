import 'package:flutter/material.dart';
import 'package:nutri_app_project/models/recipe_filters.dart';
import 'package:nutri_app_project/pages/filter_recipes_page.dart';
import 'package:nutri_app_project/widgets/recipes/filters/active_filter_chip.dart';
import 'package:nutri_app_project/widgets/recipes/filters/recipe_filter_chip.dart';

class FilterRecipes extends StatelessWidget {
  const FilterRecipes({super.key});

  Future<void> _openFilters(BuildContext context) async {
    final filters = await Navigator.push<RecipeFilters>(
      context,
      MaterialPageRoute(
        builder: (_) => const RecipeFiltersPage(),
      ),
    );

    if (filters != null) {
// Exibe os filtros selecionados no console.
      debugPrint('Tempo: ${filters.tempos}');
      debugPrint('Refeições: ${filters.refeicoes}');
      debugPrint('Ingredientes: ${filters.ingredientes}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ActiveFilterChip(
            icon: Icons.tune,
            label: 'Filtros',
            greenColor: const Color(0xFF16C768),
            onTap: () => _openFilters(context),
          ),
          const SizedBox(width: 8),
          const RecipeFilterChip(
            label: 'Tempo',
          ),
          const SizedBox(width: 8),
          const RecipeFilterChip(
            label: 'Tipo de refeição',
          ),
          const SizedBox(width: 8),
          const RecipeFilterChip(
            label: 'Ingredientes',
          ),
        ],
      ),
    );
  }
}
