
import 'package:flutter/material.dart';

import '../services/api.dart';

/// Agenda uma receita no cardápio (RF09) ou edita/reagenda uma já agendada (RF10).
/// Retorna true ao salvar.
class AddToPlanPage extends StatefulWidget {
  /// Receita pré-selecionada (ex.: vindo do detalhe da receita).
  final Map<String, dynamic>? recipe;
  final DateTime? initialDate;
  final String? initialMealType;

  /// Item do cardápio a editar; quando presente, a tela salva alterações em vez de criar.
  final Map<String, dynamic>? planItem;

  const AddToPlanPage({
    super.key,
    this.recipe,
    this.initialDate,
    this.initialMealType,
    this.planItem,
  });

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

  List<Map<String, dynamic>>? recipes;

  Map<String, dynamic>? selectedRecipe;
  late String selectedMeal;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool timeChosen = false;
  bool saving = false;

  bool get editing => widget.planItem != null;

  // name = valor do backend; label = texto curto do botão.
  final List<Map<String, dynamic>> mealTypes = [
    {'name': 'Café da manhã', 'label': 'Café', 'icon': Icons.free_breakfast_outlined, 'time': const TimeOfDay(hour: 7, minute: 30)},
    {'name': 'Almoço', 'label': 'Almoço', 'icon': Icons.wb_sunny_outlined, 'time': const TimeOfDay(hour: 12, minute: 0)},
    {'name': 'Jantar', 'label': 'Jantar', 'icon': Icons.nightlight_outlined, 'time': const TimeOfDay(hour: 19, minute: 30)},
    {'name': 'Lanche', 'label': 'Lanche', 'icon': Icons.cookie_outlined, 'time': const TimeOfDay(hour: 16, minute: 0)},
  ];

  TimeOfDay _defaultTime(String meal) =>
      mealTypes.firstWhere((m) => m['name'] == meal, orElse: () => mealTypes[1])['time'] as TimeOfDay;

  @override
  void initState() {
    super.initState();
    final item = widget.planItem;
    if (item != null) {
      selectedRecipe = item['recipe'] as Map<String, dynamic>;
      selectedMeal = item['mealType'] as String;
      selectedDate = Api.parseDay(item['day'] as String);
      final parts = (item['time'] as String).split(':');
      selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      timeChosen = true;
      observationController.text = (item['note'] as String?) ?? '';
    } else {
      selectedRecipe = widget.recipe;
      selectedMeal = widget.initialMealType ??
          (mealTypes.any((m) => m['name'] == widget.recipe?['mealType'])
              ? widget.recipe!['mealType'] as String
              : 'Almoço');
      selectedDate = DateUtils.dateOnly(widget.initialDate ?? DateTime.now());
      selectedTime = _defaultTime(selectedMeal);
    }
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
        timeChosen = true;
      });
    }
  }

  Future<void> _chooseRecipe() async {
    try {
      recipes ??= await Api.recipes();
    } catch (e) {
      _showError(e);
      return;
    }
    if (!mounted) return;
    final result = await showModalBottomSheet<Map<String, dynamic>>(
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
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: recipes!.map((recipe) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        recipe['imageUrl'] ?? '',
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
                      recipe['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${(recipe['prepTime'] as num).round()} min · ${recipe['calories'] ?? '-'} kcal · ${recipe['mealType']}',
                    ),
                    onTap: () => Navigator.pop(context, recipe),
                  );
                    }).toList(),
                  ),
                ),
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

  void _showError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Não foi possível salvar: $e')),
    );
  }

  Future<void> _addToPlan() async {
    final recipe = selectedRecipe;
    if (recipe == null) {
      _chooseRecipe();
      return;
    }
    setState(() => saving = true);
    final note = observationController.text.trim();
    try {
      if (editing) {
        await Api.updatePlanItem(
          widget.planItem!['id'] as String,
          recipeId: recipe['id'] as String,
          date: selectedDate,
          time: _formatTime(selectedTime),
          mealType: selectedMeal,
          note: note,
        );
      } else {
        await Api.addToPlan(
          recipeId: recipe['id'] as String,
          date: selectedDate,
          time: _formatTime(selectedTime),
          mealType: selectedMeal,
          note: note.isEmpty ? null : note,
        );
      }
    } catch (e) {
      setState(() => saving = false);
      _showError(e);
      return;
    }
    if (mounted) Navigator.pop(context, true);
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
        title: Text(
          editing ? 'Editar refeição' : 'Adicionar ao plano',
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
                      child: Text(selectedRecipe == null ? 'Escolher receita' : 'Trocar receita'),
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
                      return _buildMealType(
                        name: item['name'] as String,
                        label: item['label'] as String,
                        icon: item['icon'] as IconData,
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
                  onPressed: saving ? null : _addToPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: primaryGreen.withOpacity(0.22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    selectedRecipe == null
                        ? 'Escolher receita'
                        : editing
                            ? 'Salvar alterações'
                            : 'Adicionar ao plano',
                    style: const TextStyle(
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
    final recipe = selectedRecipe;
    if (recipe == null) {
      return InkWell(
        onTap: _chooseRecipe,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_circle, color: green),
              SizedBox(width: 10),
              Text('Escolher receita', style: TextStyle(color: grayText)),
            ],
          ),
        ),
      );
    }
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
              recipe['imageUrl'] ?? '',
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
                  recipe['name'],
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
                      '${(recipe['prepTime'] as num).round()} min',
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
                      recipe['difficulty'] ?? '-',
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
                      '${recipe['calories'] ?? '-'} kcal',
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
    required String label,
    required IconData icon,
  }) {
    final selected = selectedMeal == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeal = name;
          if (!timeChosen) selectedTime = _defaultTime(name);
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
                label,
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
