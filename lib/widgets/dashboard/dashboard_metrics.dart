import 'package:flutter/material.dart';

import 'package:nutri_app_project/widgets/dashboard/cards/metric_card.dart';

/// Métricas do dia: refeições feitas, calorias consumidas, meta e água.
class DashboardMetrics extends StatelessWidget {
  static const int waterGoalMl = 2000;

  final int mealsDone;
  final int mealsPlanned;
  final int calories;
  final int waterMl;
  final VoidCallback onAddWater;

  const DashboardMetrics({
    super.key,
    required this.mealsDone,
    required this.mealsPlanned,
    required this.calories,
    required this.waterMl,
    required this.onAddWater,
  });

  String _liters(int ml) {
    final liters = ml / 1000;
    return liters == liters.roundToDouble()
        ? '${liters.round()}L'
        : '${liters.toStringAsFixed(1).replaceAll('.', ',')}L';
  }

  @override
  Widget build(BuildContext context) {
    final goal = mealsPlanned == 0 ? '—' : '${(mealsDone * 100 / mealsPlanned).round()}%';
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 10,
      childAspectRatio: 1.65,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MetricCard(
          icon: Icons.restaurant_rounded,
          iconColor: const Color(0xFF16A34A),
          iconBackground: const Color(0xFFEAF8EF),
          title: 'Refeições hoje',
          value: '$mealsDone / $mealsPlanned',
        ),
        MetricCard(
          icon: Icons.local_fire_department_rounded,
          iconColor: const Color(0xFFFF3B30),
          iconBackground: const Color(0xFFFFF0EF),
          title: 'Calorias consumidas',
          value: '$calories kcal',
        ),
        MetricCard(
          icon: Icons.adjust_rounded,
          iconColor: const Color(0xFF448AFF),
          iconBackground: const Color(0xFFEEF4FF),
          title: 'Meta diária',
          value: goal,
        ),
        GestureDetector(
          onTap: onAddWater,
          child: MetricCard(
            icon: Icons.water_drop_outlined,
            iconColor: const Color(0xFF00AEEF),
            iconBackground: const Color(0xFFEAF9FD),
            title: 'Água (toque: +250 ml)',
            value: '${_liters(waterMl)} / ${_liters(waterGoalMl)}',
          ),
        ),
      ],
    );
  }
}
