
import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'recipe_details.dart';

const Color appGreen = Color(0xFF16C768);
const Color appDarkGreen = Color(0xFF07883B);
const Color appText = Color(0xFF182033);
const Color appGray = Color(0xFF687184);
const Color appBorder = Color(0xFFE0E5EC);

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late DateTime selectedDate;

  final Map<String, List<MealItem>> mealsByDate = {};

  final List<String> weekdays = const [
    'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',
  ];

  @override
  void initState() {
    super.initState();

    selectedDate = DateUtils.dateOnly(DateTime.now());

    // Refeições de demonstração para o dia inicial.
    mealsByDate[_dateKey(selectedDate)] = [
      MealItem(
        category: 'Café da manhã',
        title: 'Overnight Oats com Frutas',
        time: '07:30',
        imageUrl:
        'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?auto=format&fit=crop&w=300&q=80',
      ),
      MealItem(
        category: 'Almoço',
        title: 'Salmão ao forno com batata-doce',
        time: '12:00',
        imageUrl:
        'https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&w=300&q=80',
      ),
      MealItem(
        category: 'Jantar',
        title: 'Salada Caesar com Frango',
        time: '19:30',
        imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=300&q=80',
      ),
    ];
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  List<MealItem> get selectedMeals =>
      mealsByDate[_dateKey(selectedDate)] ?? [];

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
      setState(() {
        selectedDate = DateUtils.dateOnly(result);
      });
    }
  }

  void _changeDay(DateTime date) {
    setState(() {
      selectedDate = DateUtils.dateOnly(date);
    });
  }

  Future<void> _addMeal() async {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '12:00');

    String category = 'Lanche';

    final result = await showDialog<MealItem>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Adicionar refeição'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da refeição',
                        hintText: 'Ex.: Sanduíche natural',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                      ),
                      items: const [
                        'Café da manhã',
                        'Almoço',
                        'Jantar',
                        'Lanche',
                      ].map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => category = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Horário',
                        hintText: '12:00',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final time = timeController.text.trim();

                    if (title.isEmpty || time.isEmpty) return;

                    Navigator.pop(
                      dialogContext,
                      MealItem(
                        category: category,
                        title: title,
                        time: time,
                        imageUrl: '',
                      ),
                    );
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    timeController.dispose();

    if (result != null && mounted) {
      setState(() {
        mealsByDate.putIfAbsent(_dateKey(selectedDate), () => []);
        mealsByDate[_dateKey(selectedDate)]!.add(result);
      });
    }
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
              'Você pode adicionar refeições pelo botão '
              '"Adicionar refeição" ou remover refeições tocando '
              'no ícone de lixeira de cada cartão.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
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
                ),                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildWeekSelector(),
                  const SizedBox(height: 18),
                  const Divider(color: appBorder, height: 1),
                  const SizedBox(height: 18),
                  ..._buildMealSections(),
                  const SizedBox(height: 18),
                  _buildAddMealButton(),
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
    const categories = [
      'Café da manhã',
      'Almoço',
      'Jantar',
      'Lanche',
    ];

    const defaultTimes = {
      'Café da manhã': '07:30',
      'Almoço': '12:00',
      'Jantar': '19:30',
      'Lanche': '16:00',
    };

    return categories.map((category) {
      final categoryMeals = selectedMeals
          .where((meal) => meal.category == category)
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
                      ? categoryMeals.first.time
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

  Widget _buildMealCard(MealItem meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: appBorder),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: meal.imageUrl.isEmpty
                ? Container(
              width: 64,
              height: 64,
              color: const Color(0xFFE8F8EE),
              child: const Icon(
                Icons.restaurant,
                color: appDarkGreen,
              ),
            )
                : Image.network(
              meal.imageUrl,
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
                  meal.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: appText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecipeDetailPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
            tooltip: 'Remover refeição',
            onPressed: () {
              setState(() {
                mealsByDate[_dateKey(selectedDate)]?.remove(meal);
              });
            },
            icon: const Icon(
              Icons.close,
              color: appGray,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMeal(String category) {
    return InkWell(
      onTap: _addMeal,
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
          children: [
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

  Widget _buildAddMealButton() {
    return OutlinedButton.icon(
      onPressed: _addMeal,
      icon: const Icon(Icons.add, size: 20),
      label: const Text('Adicionar refeição'),
      style: OutlinedButton.styleFrom(
        foregroundColor: appDarkGreen,
        side: const BorderSide(color: appGreen),
        minimumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
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

class MealItem {
  final String category;
  final String title;
  final String time;
  final String imageUrl;

  MealItem({
    required this.category,
    required this.title,
    required this.time,
    required this.imageUrl,
  });
}
