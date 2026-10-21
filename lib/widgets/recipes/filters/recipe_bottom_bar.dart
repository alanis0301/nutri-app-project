import 'package:flutter/material.dart';

class RecipesBottomBar extends StatelessWidget {
  final VoidCallback onApplyFilters;
  final Color verde;
  final int? count;

  const RecipesBottomBar({
    super.key,
    required this.onApplyFilters,
    required this.verde,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE1E5EB)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count == null
                  ? 'Contando receitas...'
                  : count == 1
                      ? '1 receita encontrada'
                      : '$count receitas encontradas',
              style: TextStyle(
                color: Color(0xFF737B8C),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: onApplyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Aplicar filtros',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
