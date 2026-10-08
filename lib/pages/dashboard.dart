import 'package:flutter/material.dart';

import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_metrics.dart';
import '../widgets/dashboard/cards/next_meal_card.dart';
import '../widgets/dashboard/dashboard_suggestions.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 24),
            const DashboardMetrics(),
            const SizedBox(height: 12),
            const NextMealHeader(),
            const SizedBox(height: 10),
            const DashboardSuggestions(),
          ],
        ),
      ),
    );
  }
}
