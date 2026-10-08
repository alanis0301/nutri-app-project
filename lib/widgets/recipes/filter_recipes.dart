import 'package:flutter/material.dart';

class FilterRecipes extends StatelessWidget {
  const FilterRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActiveFilterChip(
            icon: Icons.tune,
            label: 'Filtros',
            greenColor: Color(0xFF16C768),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(label: 'Tempo'),
          const SizedBox(width: 8),
          _buildFilterChip(label: 'Tipo de refeição'),
          const SizedBox(width: 8),
          _buildFilterChip(label: 'Ingredientes'),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip({
    required IconData icon,
    required String label,
    required Color greenColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: greenColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: greenColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: greenColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: greenColor,
            ),
          ),
        ],
      ),
    );
  }

// Chip Inativo
  Widget _buildFilterChip({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E5EB)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF697386),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
