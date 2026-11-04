import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_metrics.dart';
import '../widgets/dashboard/cards/next_meal_card.dart';
import '../widgets/dashboard/dashboard_suggestions.dart';
import 'recipe_details.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback onOpenAgenda;

  const DashboardPage({super.key, required this.onOpenAgenda});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07863D);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);
  static const Color lightGreen = Color(0xFFF0FBF4);

  late Future<_DashboardData> data = _load();

  Future<_DashboardData> _load() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final results = await Future.wait([
      Api.me(),
      Api.plan(monday, monday.add(const Duration(days: 6))),
      Api.water(today),
      Api.recommendedRecipes(2),
    ]);
    final week = results[1] as List<Map<String, dynamic>>;
    return _DashboardData(
      user: results[0] as Map<String, dynamic>,
      week: week,
      today: week.where((m) => m['day'] == Api.day(today)).toList(),
      water: results[2] as int,
      suggestions: results[3] as List<Map<String, dynamic>>,
    );
  }

  Future<void> _addWater(_DashboardData current) async {
    final total = await Api.addWater(DateTime.now(), 250);
    setState(() => current.water = total);
  }

  void _openRecipe(Map<String, dynamic> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
    ).then((_) => setState(() => data = _load()));
  }

  /// Próxima refeição de hoje ainda não feita (a partir do horário atual, ou a primeira pendente).
  Map<String, dynamic>? _nextMeal(List<Map<String, dynamic>> today) {
    final now = TimeOfDay.now();
    final nowText =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final pending = today.where((m) => m['done'] != true).toList();
    for (final meal in pending) {
      if ((meal['time'] as String).compareTo(nowText) >= 0) return meal;
    }
    return pending.isEmpty ? null : pending.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<_DashboardData>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _ErrorRetry(
                message: '${snapshot.error}',
                onRetry: () => setState(() => data = _load()),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: green));
            }
            final d = snapshot.data!;
            final done = d.today.where((m) => m['done'] == true).toList();
            final calories = done.fold<int>(
                0, (sum, m) => sum + ((m['recipe']['calories'] as int?) ?? 0));
            return RefreshIndicator(
              color: green,
              onRefresh: () async {
                setState(() => data = _load());
                await data;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardHeader(
                      name: d.user['name'] as String,
                      onPreferencesSaved: () => setState(() => data = _load()),
                    ),
                    const SizedBox(height: 24),
                    DashboardMetrics(
                      mealsDone: done.length,
                      mealsPlanned: d.today.length,
                      calories: calories,
                      waterMl: d.water,
                      onAddWater: () => _addWater(d),
                    ),
                    const SizedBox(height: 12),
                    NextMealHeader(
                      meal: _nextMeal(d.today),
                      onTap: _openRecipe,
                      onPlanMeal: widget.onOpenAgenda,
                    ),
                    const SizedBox(height: 10),
                    DashboardSuggestions(
                      recipes: d.suggestions,
                      onTap: _openRecipe,
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Seu plano da semana',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildPlanCard(d),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlanCard(_DashboardData d) {
    final goal = d.user['goal']?['name'] as String?;
    final doneWeek = d.week.where((m) => m['done'] == true).length;
    final days = d.week.map((m) => m['day']).toSet().length;

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
          Text(
            d.week.isEmpty ? 'Nenhuma refeição planejada' : 'Cardápio da semana',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            goal == null
                ? 'Defina seu objetivo nas preferências para receber sugestões.'
                : 'Baseado no seu objetivo: ${goal.toLowerCase()}',
            style: const TextStyle(fontSize: 13, color: grayText),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.restaurant, size: 16, color: grayText),
              const SizedBox(width: 6),
              Text(
                '$doneWeek de ${d.week.length} refeições feitas',
                style: const TextStyle(fontSize: 12, color: grayText),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today_outlined, size: 15, color: grayText),
              const SizedBox(width: 6),
              Text(
                '$days ${days == 1 ? 'dia' : 'dias'} com plano',
                style: const TextStyle(fontSize: 12, color: grayText),
              ),
            ],
          ),
          if (goal != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: green),
              ),
              child: Text(
                goal,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: darkGreen,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onOpenAgenda,
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: green.withOpacity(0.22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                d.week.isEmpty ? 'Montar meu plano' : 'Ver plano',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardData {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> week;
  final List<Map<String, dynamic>> today;
  final List<Map<String, dynamic>> suggestions;
  int water;

  _DashboardData({
    required this.user,
    required this.week,
    required this.today,
    required this.water,
    required this.suggestions,
  });
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Não foi possível carregar: $message', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Tentar de novo')),
          ],
        ),
      ),
    );
  }
}
