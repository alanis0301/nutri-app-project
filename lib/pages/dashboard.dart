import 'package:flutter/material.dart';

import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_metrics.dart';
import '../widgets/dashboard/cards/next_meal_card.dart';
import '../widgets/dashboard/dashboard_suggestions.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07863D);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);
  static const Color lightGreen = Color(0xFFF0FBF4);

  static const List<Map<String, String>> recipes = [
    {
      'title': 'Omelete de Claras com Espinafre',
      'time': '15 min',
      'difficulty': 'Fácil',
      'image':
      'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Bowl de Frango com Batata-doce',
      'time': '25 min',
      'difficulty': 'Fácil',
      'image':
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Salada de Abacate e Ovo',
      'time': '10 min',
      'difficulty': 'Fácil',
      'image':
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Wrap Integral de Frango',
      'time': '20 min',
      'difficulty': 'Fácil',
      'image':
      'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=400&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
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
              const SizedBox(height: 24),
              const SizedBox(height: 28),
              const Text(
                'Plano sugerido para você',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 14),
              _buildPlanCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plano Equilíbrio Semanal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Baseado no seu objetivo de mais disposição',
            style: TextStyle(fontSize: 13, color: grayText),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: grayText),
              const SizedBox(width: 6),
              const Text(
                '5 refeições/dia',
                style: TextStyle(fontSize: 12, color: grayText),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today_outlined, size: 15, color: grayText),
              const SizedBox(width: 6),
              const Text(
                'Segunda a sexta',
                style: TextStyle(fontSize: 12, color: grayText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: green),
            ),
            child: const Text(
              'Mais disposição',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: darkGreen,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: green.withOpacity(0.22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Ver plano',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

