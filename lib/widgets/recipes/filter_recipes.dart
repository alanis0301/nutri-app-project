import 'package:flutter/material.dart';
import 'package:nutri_app_project/models/recipe_filters.dart';

/// Chips de filtro da tela de receitas. Qualquer chip abre a tela de filtros;
/// o chip fica verde quando há filtro daquele tipo aplicado.
class FilterRecipes extends StatelessWidget {
  final RecipeFilters filters;
  final VoidCallback onOpenFilters;

  const FilterRecipes({
    super.key,
    required this.filters,
    required this.onOpenFilters,
  });

  static const Color green = Color(0xFF16C768);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(icon: Icons.tune, label: 'Filtros', active: !filters.isEmpty),
          const SizedBox(width: 8),
          _chip(label: 'Tempo', active: filters.tempos.isNotEmpty),
          const SizedBox(width: 8),
          _chip(label: 'Tipo de refeição', active: filters.refeicoes.isNotEmpty),
          const SizedBox(width: 8),
          _chip(label: 'Ingredientes', active: filters.ingredientes.isNotEmpty),
        ],
      ),
    );
  }

  Widget _chip({IconData? icon, required String label, required bool active}) {
    return InkWell(
      onTap: onOpenFilters,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE8F8EE) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? green : const Color(0xFFE1E5EB)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: active ? green : const Color(0xFF697386)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? green : const Color(0xFF697386),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
