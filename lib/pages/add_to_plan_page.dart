
import 'package:flutter/material.dart';

class AddToPlanPage extends StatefulWidget {
  const AddToPlanPage({super.key});

  @override
  State<AddToPlanPage> createState() => _AddToPlanPageState();
}

class _AddToPlanPageState extends State<AddToPlanPage> {
  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07863D);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);

  final TextEditingController observationController =
  TextEditingController();

  final List<Map<String, String>> recipes = [
    {
      'title': 'Salmão ao forno com batata-doce',
      'time': '30 min',
      'difficulty': 'Fácil',
      'calories': '420 kcal',
      'image':
      'https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&w=300&q=80',
    },
    {
      'title': 'Overnight Oats com Frutas',
      'time': '10 min',
      'difficulty': 'Fácil',
      'calories': '280 kcal',
      'image':
      'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?auto=format&fit=crop&w=300&q=80',
    },
    {
      'title': 'Salada Caesar com Frango',
      'time': '20 min',
      'difficulty': 'Fácil',
      'calories': '350 kcal',
      'image':
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=300&q=80',
    },
    {
      'title': 'Wrap de frango',
      'time': '20 min',
      'difficulty': 'Fácil',
      'calories': '320 kcal',
      'image':
      'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=300&q=80',
    },
  ];

  late Map<String, String> selectedRecipe;
  String selectedMeal = 'Almoço';
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());
  TimeOfDay selectedTime = const TimeOfDay(hour: 12, minute: 0);

  final List<Map<String, dynamic>> mealTypes = [
    {'name': 'Café', 'icon': Icons.free_breakfast_outlined},
    {'name': 'Almoço', 'icon': Icons.wb_sunny_outlined},
    {'name': 'Jantar', 'icon': Icons.nightlight_outlined},
    {'name': 'Lanche', 'icon': Icons.cookie_outlined},
  ];

  @override
  void initState() {
    super.initState();
    selectedRecipe = recipes.first;
  }

  @override
  void dispose() {
    observationController.dispose();
    super.dispose();
  }

  String _weekdayName(DateTime date) {
    const days = [
      'Seg',
      'Ter',
      'Qua',
      'Qui',
      'Sex',
      'Sáb',
      'Dom',
    ];

    return days[date.weekday - 1];
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  DateTime _mondayOfWeek(DateTime date) {
    return DateUtils.dateOnly(
      date.subtract(Duration(days: date.weekday - 1)),
    );
  }

  Future<void> _chooseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Selecionar dia da refeição',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (result != null && mounted) {
      setState(() {
        selectedDate = DateUtils.dateOnly(result);
      });
    }
  }

  Future<void> _chooseTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      helpText: 'Escolher horário',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (result != null && mounted) {
      setState(() {
        selectedTime = result;
      });
    }
  }

  Future<void> _chooseRecipe() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Escolher receita',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 16),
                ...recipes.map((recipe) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        recipe['image']!,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 52,
                          height: 52,
                          color: const Color(0xFFF0FBF4),
                          child: const Icon(
                            Icons.restaurant,
                            color: green,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      recipe['title']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${recipe['time']} · ${recipe['calories']}',
                    ),
                    onTap: () => Navigator.pop(context, recipe),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        selectedRecipe = result;
      });
    }
  }

  void _addToPlan() {
    final meal = <String, dynamic>{
      'recipe': selectedRecipe['title'],
      'image': selectedRecipe['image'],
      'mealType': selectedMeal,
      'date': selectedDate,
      'time': _formatTime(selectedTime),
      'observation': observationController.text.trim(),
    };

    // Retorna a refeição para a tela anterior.
    // A AgendaPage poderá receber esse resultado e atualizar sua lista.
    Navigator.pop(context, meal);
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = _mondayOfWeek(selectedDate);
    const Color primaryGreen = Color(0xFF19C45A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Adicionar ao plano',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: darkText,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.cancel_outlined,
              color: darkText,
              size: 21,
            ),
          ),
          const SizedBox(width: 6),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: borderColor),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                children: [
                  _buildRecipeCard(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _chooseRecipe,
                      style: TextButton.styleFrom(
                        foregroundColor: darkGreen,
                      ),
                      child: const Text('Trocar receita'),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const _FormLabel('Em qual refeição?'),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mealTypes.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 64,
                    ),
                    itemBuilder: (context, index) {
                      final item = mealTypes[index];
                      final name = item['name'] as String;
                      final icon = item['icon'] as IconData;

                      return _buildMealType(
                        name: name,
                        icon: icon,
                      );
                    },
                  ),

                  const SizedBox(height: 26),
                  const _FormLabel('Em qual dia?'),
                  const SizedBox(height: 12),

                  Row(
                    children: List.generate(7, (index) {
                      final date = weekStart.add(Duration(days: index));
                      final selected = DateUtils.isSameDay(
                        date,
                        selectedDate,
                      );

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == 6 ? 0 : 5,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: selected
                                      ? green
                                      : const Color(0xFFF0F1F4),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _weekdayName(date),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: selected
                                          ? Colors.white
                                          : grayText,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : darkText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _chooseDate,
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        size: 17,
                      ),
                      label: const Text('Escolher outra data'),
                      style: TextButton.styleFrom(
                        foregroundColor: darkGreen,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const _FormLabel('Horário'),
                  const SizedBox(height: 8),

                  InkWell(
                    onTap: _chooseTime,
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: grayText,
                            size: 21,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatTime(selectedTime),
                            style: const TextStyle(
                              fontSize: 14,
                              color: darkText,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: grayText,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),
                  const _FormLabel('Observação (opcional)'),
                  const SizedBox(height: 8),

                  TextField(
                    controller: observationController,
                    minLines: 3,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText:
                      'Ex: Sem pimenta, trocar brócolis por aspargos...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: grayText,
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: borderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: green,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addToPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: primaryGreen.withOpacity(0.22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Adicionar ao plano',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.network(
              selectedRecipe['image']!,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: const Color(0xFFF0FBF4),
                child: const Icon(
                  Icons.restaurant,
                  color: green,
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
                  selectedRecipe['title']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 13,
                      color: grayText,
                    ),
                    Text(
                      selectedRecipe['time']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: grayText,
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(color: grayText),
                    ),
                    Text(
                      selectedRecipe['difficulty']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: grayText,
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(color: grayText),
                    ),
                    Text(
                      selectedRecipe['calories']!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealType({
    required String name,
    required IconData icon,
  }) {
    final selected = selectedMeal == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeal = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FBF4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? green : borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: selected ? Colors.white : const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 19,
                color: selected ? darkGreen : darkText,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? darkGreen : darkText,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check,
                size: 18,
                color: darkGreen,
              ),
          ],
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;

  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1C1E),
      ),
    );
  }
}
