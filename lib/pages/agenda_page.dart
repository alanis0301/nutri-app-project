
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'add_to_plan_page.dart';
import 'calendar_page.dart';
import 'recipe_details.dart';

const Color appGreen = Color(0xFF16C768);
const Color appDarkGreen = Color(0xFF07883B);
const Color appText = Color(0xFF182033);
const Color appGray = Color(0xFF687184);
const Color appBorder = Color(0xFFE0E5EC);

/// Cardápio semanal (RF08–RF10): refeições por dia vindas do backend.
class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late DateTime selectedDate;

  /// Refeições da semana exibida, carregadas do backend.
  List<Map<String, dynamic>>? weekMeals;
  String? error;
  DateTime? loadedWeek;

  final List<String> weekdays = const [
    'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',
  ];

  static const categories = [
    'Café da manhã',
    'Almoço',
    'Jantar',
    'Lanche',
  ];

  static const defaultTimes = {
    'Café da manhã': '07:30',
    'Almoço': '12:00',
    'Jantar': '19:30',
    'Lanche': '16:00',
  };

  @override
  void initState() {
    super.initState();
    selectedDate = DateUtils.dateOnly(DateTime.now());
    _loadWeek();
  }

  Future<void> _loadWeek() async {
    final start = weekStart;
    setState(() {
      loadedWeek = start;
      error = null;
    });
    try {
      final meals = await Api.plan(start, start.add(const Duration(days: 6)));
      if (mounted && loadedWeek == start) setState(() => weekMeals = meals);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  List<Map<String, dynamic>> get selectedMeals => (weekMeals ?? [])
      .where((m) => m['day'] == Api.day(selectedDate))
      .toList();

  DateTime get weekStart =>
      DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day - selectedDate.weekday + 1);

  String _monthName(int month) {
    const months = [
      'janeiro', 'fevereiro', 'março', 'abril',
      'maio', 'junho', 'julho', 'agosto',
      'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    return months[month - 1];
  }

  String _shortMonth(int month) {
    const months = [
      'jan.', 'fev.', 'mar.', 'abr.', 'mai.', 'jun.',
      'jul.', 'ago.', 'set.', 'out.', 'nov.', 'dez.',
    ];
    return months[month - 1];
  }

  String _weekLabel() {
    final end = weekStart.add(const Duration(days: 6));

    if (weekStart.month == end.month) {
      return '${weekStart.day} a ${end.day} de ${_monthName(end.month)}';
    }

    return '${weekStart.day} ${_shortMonth(weekStart.month)} a '
        '${end.day} ${_shortMonth(end.month)}';
  }

  Future<void> _openCalendar() async {
    final result = await Navigator.push<DateTime>(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarPage(initialDate: selectedDate),
      ),
    );

    if (result != null && mounted) {
      _changeDay(result);
    }
  }

  void _changeDay(DateTime date) {
    final previousWeek = weekStart;
    setState(() {
      selectedDate = DateUtils.dateOnly(date);
    });
    if (weekStart != previousWeek) _loadWeek();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível atualizar: $e')),
        );
      }
    }
    await _loadWeek();
  }

  Future<void> _addMeal([String? mealType]) async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddToPlanPage(
          initialDate: selectedDate,
          initialMealType: mealType,
        ),
      ),
    );
    if (added == true) _loadWeek();
  }

  Future<void> _editMeal(Map<String, dynamic> meal) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddToPlanPage(planItem: meal)),
    );
    if (saved == true) _loadWeek();
  }

  Future<void> _editPlan() async {
    final dateLabel =
        '${selectedDate.day} de ${_monthName(selectedDate.month)}';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar plano'),
        content: Text(
          'Plano do dia $dateLabel.\n\n'
              'Toque em "Adicionar refeição" para incluir uma receita, '
              'toque no cartão para trocar a receita, o dia ou o horário, '
              'marque o círculo quando fizer a refeição e use o X para remover.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _addMeal();
            },
            child: const Text('Adicionar refeição'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  30,
                ),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildWeekSelector(),
                  const SizedBox(height: 18),
                  const Divider(color: appBorder, height: 1),
                  const SizedBox(height: 18),
                  if (error != null)
                    Column(
                      children: [
                        Text('Não foi possível carregar o plano: $error'),
                        TextButton(
                          onPressed: _loadWeek,
                          child: const Text('Tentar de novo'),
                        ),
                      ],
                    )
                  else if (weekMeals == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: appGreen),
                      ),
                    )
                  else
                    ..._buildMealSections(),
                ],
              ),
            ),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Meu plano',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1E),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: Color(0xFF1A1C1E),
                        size: 20,
                      ),
                      onPressed: _openCalendar,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekSelector() {
    final daysWithMeals = (weekMeals ?? []).map((m) => m['day']).toSet();
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => _changeDay(
                selectedDate.subtract(const Duration(days: 7)),
              ),
              icon: const Icon(Icons.chevron_left, size: 30),
            ),
            Expanded(
              child: Text(
                _weekLabel(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: appText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _changeDay(
                selectedDate.add(const Duration(days: 7)),
              ),
              icon: const Icon(Icons.chevron_right, size: 30),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(7, (index) {
            final date = weekStart.add(Duration(days: index));
            final isSelected = DateUtils.isSameDay(date, selectedDate);
            final hasMeals = daysWithMeals.contains(Api.day(date));

            return Expanded(
              child: GestureDetector(
                onTap: () => _changeDay(date),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? appGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Column(
                    children: [
                      Text(
                        weekdays[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : appGray,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : appText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Ponto indica dia com refeições planejadas.
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasMeals
                              ? (isSelected ? Colors.white : appGreen)
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  List<Widget> _buildMealSections() {
    return categories.map((category) {
      final categoryMeals = selectedMeals
          .where((meal) => meal['mealType'] == category)
          .toList();

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: appText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  categoryMeals.isNotEmpty
                      ? categoryMeals.first['time'] as String
                      : defaultTimes[category]!,
                  style: const TextStyle(
                    color: appGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            if (categoryMeals.isEmpty)
              _buildEmptyMeal(category)
            else
              ...categoryMeals.map(_buildMealCard),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    final recipe = meal['recipe'] as Map<String, dynamic>;
    final done = meal['done'] == true;
    return InkWell(
      onTap: () => _editMeal(meal),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: done ? const Color(0xFFF0FBF4) : Colors.white,
          border: Border.all(color: done ? appGreen : appBorder),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe['imageUrl'] ?? '',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xFFE8F8EE),
                  child: const Icon(
                    Icons.restaurant,
                    color: appDarkGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: appText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${meal['time']} · ${recipe['calories'] ?? '-'} kcal'
                    '${(meal['note'] as String?)?.isNotEmpty == true ? ' · ${meal['note']}' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: appGray, fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailPage(recipe: recipe),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Ver receita',
                          style: TextStyle(
                            color: appDarkGreen,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: appDarkGreen,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: done ? 'Desmarcar como feita' : 'Marcar como feita',
              onPressed: () => _run(
                () => Api.updatePlanItem(meal['id'] as String, done: !done),
              ),
              icon: Icon(
                done ? Icons.check_circle : Icons.radio_button_unchecked,
                color: done ? appGreen : appGray,
              ),
            ),
            IconButton(
              tooltip: 'Remover refeição',
              onPressed: () => _run(
                () => Api.removePlanItem(meal['id'] as String),
              ),
              icon: const Icon(
                Icons.close,
                color: appGray,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMeal(String category) {
    return InkWell(
      onTap: () => _addMeal(category),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          border: Border.all(
            color: appBorder,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_circle, color: appGreen, size: 22),
            SizedBox(width: 10),
            Text(
              'Adicionar refeição',
              style: TextStyle(color: appGray, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton(
          onPressed: _editPlan,
          style: OutlinedButton.styleFrom(
            foregroundColor: appDarkGreen,
            side: const BorderSide(color: appGreen, width: 1.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Editar plano',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
