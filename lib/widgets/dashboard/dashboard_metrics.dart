import 'package:flutter/material.dart';

import 'package:nutri_app_project/widgets/dashboard/cards/metric_card.dart';

class DashboardMetrics extends StatelessWidget {
const DashboardMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(

      crossAxisCount: 2,

      crossAxisSpacing: 8,
      mainAxisSpacing: 10,

      childAspectRatio: 1.65,

      shrinkWrap: true,

      physics:
      const NeverScrollableScrollPhysics(),

      children: [

        const MetricCard(
          icon: Icons.restaurant_rounded,
          iconColor: const Color(0xFF16A34A),
          iconBackground: const Color(0xFFEAF8EF),
          title: 'Refeições',
          value: '3 / 5',
        ),

        const MetricCard(
          icon:
          Icons.local_fire_department_rounded,
          iconColor: const Color(0xFFFF3B30),
          iconBackground: const Color(0xFFFFF0EF),
          title: 'Calorias',
          value: '1.250 kcal',
        ),

        const MetricCard(
          icon: Icons.adjust_rounded,
          iconColor: const Color(0xFF448AFF),
          iconBackground: const Color(0xFFEEF4FF),
          title: 'Meta Diária',
          value: '68%',
        ),

        const MetricCard(
          icon: Icons.water_drop_outlined,
          iconColor: const Color(0xFF00AEEF),
          iconBackground: const Color(0xFFEAF9FD),
          title: 'Água',
          value: '1.2L / 2L',
        ),
      ],
    );
  }
}