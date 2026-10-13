import 'package:flutter/material.dart';
import 'agenda_page.dart';

class CalendarPage extends StatefulWidget {
  final DateTime initialDate;

  const CalendarPage({
    super.key,
    required this.initialDate,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime displayedMonth;
  late DateTime selectedDate;

  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07883B);
  static const Color textColor = Color(0xFF182033);
  static const Color gray = Color(0xFF687184);
  static const Color border = Color(0xFFE0E5EC);

  final List<String> months = const [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  final List<String> weekdays = const [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateUtils.dateOnly(widget.initialDate);
    displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
  }

  void _changeMonth(int amount) {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month + amount,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = DateUtils.dateOnly(date);
    });

    // Retorna a data selecionada para a Agenda.
    Navigator.pop<DateTime>(context, selectedDate);
  }

  Future<void> _chooseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
      locale: const Locale('pt', 'BR'),
      helpText: 'Selecionar data',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: green,
              onPrimary: Colors.white,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        selectedDate = DateUtils.dateOnly(result);
        displayedMonth = DateTime(result.year, result.month);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      displayedMonth.year,
      displayedMonth.month,
    );

    // O calendário começa na segunda-feira.
    final firstWeekdayOffset =
        (DateTime(displayedMonth.year, displayedMonth.month, 1).weekday -
                DateTime.monday) %
            7;

    final cellCount = firstWeekdayOffset + daysInMonth;
    final rowCount = (cellCount / 7).ceil();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 84,
          titleSpacing: 20,
          title: Row(
            children: [
              const Expanded(
                child: Text(
                  'Calendário',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1E),
                  ),
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
                    Icons.calendar_today_outlined,
                    color: Color(0xFF1A1C1E),
                    size: 20,
                  ),
                  tooltip: 'Escolher uma data',
                  onPressed: _chooseDate,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            30,
          ),            children: [
            _buildMonthHeader(),
            const SizedBox(height: 24),
            _buildWeekdayHeaders(),
            const SizedBox(height: 10),
            _buildCalendarGrid(
              firstWeekdayOffset,
              daysInMonth,
              rowCount,
            ),
            const SizedBox(height: 24),
            _buildSelectedDateCard(),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => _selectDate(selectedDate),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Ver agenda deste dia',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _chooseDate,
              style: OutlinedButton.styleFrom(
                foregroundColor: darkGreen,
                side: const BorderSide(color: green),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Escolher uma data específica'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _changeMonth(-1),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
        Expanded(
          child: Column(
            children: [
              DropdownButton<int>(
                value: displayedMonth.month,
                underline: const SizedBox.shrink(),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
                items: List.generate(12, (index) {
                  final month = index + 1;
                  return DropdownMenuItem(
                    value: month,
                    child: Text(months[index]),
                  );
                }),
                onChanged: (month) {
                  if (month != null) {
                    setState(() {
                      displayedMonth = DateTime(
                        displayedMonth.year,
                        month,
                      );
                    });
                  }
                },
              ),
              DropdownButton<int>(
                value: displayedMonth.year,
                underline: const SizedBox.shrink(),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                style: const TextStyle(
                  color: gray,
                  fontSize: 14,
                ),
                items: List.generate(101, (index) {
                  final year = 2000 + index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text('$year'),
                  );
                }),
                onChanged: (year) {
                  if (year != null) {
                    setState(() {
                      displayedMonth = DateTime(
                        year,
                        displayedMonth.month,
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _changeMonth(1),
          icon: const Icon(Icons.chevron_right, size: 30),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                color: gray,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(
    int offset,
    int daysInMonth,
    int rowCount,
  ) {
    final cellCount = rowCount * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cellCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - offset + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(
          displayedMonth.year,
          displayedMonth.month,
          dayNumber,
        );

        final isSelected = DateUtils.isSameDay(date, selectedDate);
        final isToday = DateUtils.isSameDay(date, DateTime.now());

        return Material(
          color: isSelected ? green : Colors.transparent,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: isToday && !isSelected ? green : Colors.transparent,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$dayNumber',
                style: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontSize: 14,
                  fontWeight:
                      isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedDateCard() {
    final dateLabel =
        '${selectedDate.day} de ${months[selectedDate.month - 1]} de '
        '${selectedDate.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FBF5),
        border: Border.all(color: const Color(0xFFD6F3E0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_outlined,
            color: darkGreen,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data selecionada',
                  style: TextStyle(
                    color: gray,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateLabel,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Voltar para hoje',
            onPressed: () {
              setState(() {
                selectedDate = DateUtils.dateOnly(DateTime.now());
                displayedMonth = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                );
              });
            },
            icon: const Icon(
              Icons.today_outlined,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
