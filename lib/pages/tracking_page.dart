import 'package:flutter/material.dart';

import '../services/api.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  static const Color green = Color(0xFF16C768);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);
  static const Color cardBg = Color(0xFFF8F9FB);
  static const Color trackGray = Color(0xFFE9EAED);

  final List<String> periods = ['Semana', 'Mês', 'Ano'];
  int selectedPeriod = 0;

  Map<String, dynamic>? stats;
  String? error;

  // Barras do gráfico: rótulo + planejadas/feitas, agrupadas por dia, semana ou mês.
  List<String> labels = [];
  List<int> planned = [];
  List<int> done = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Período atual: semana (seg–dom), mês ou ano corrente.
  List<DateTime> _range() {
    final today = DateUtils.dateOnly(DateTime.now());
    switch (selectedPeriod) {
      case 0:
        final monday = today.subtract(Duration(days: today.weekday - 1));
        return [monday, monday.add(const Duration(days: 6))];
      case 1:
        return [
          DateTime(today.year, today.month, 1),
          DateTime(today.year, today.month + 1, 0),
        ];
      default:
        return [DateTime(today.year, 1, 1), DateTime(today.year, 12, 31)];
    }
  }

  Future<void> _load() async {
    final period = selectedPeriod;
    setState(() {
      stats = null;
      error = null;
    });
    final range = _range();
    try {
      final result = await Api.stats(range[0], range[1]);
      if (!mounted || period != selectedPeriod) return;
      _bucket(result, range[0], range[1]);
      setState(() => stats = result);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  void _bucket(Map<String, dynamic> result, DateTime start, DateTime end) {
    const weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    final int count;
    int Function(DateTime) index;
    if (selectedPeriod == 0) {
      labels = weekdays;
      count = 7;
      index = (d) => d.weekday - 1;
    } else if (selectedPeriod == 1) {
      // Semanas do mês (dias 1–7, 8–14, ...).
      count = ((end.day - 1) ~/ 7) + 1;
      labels = List.generate(count, (i) => 'S${i + 1}');
      index = (d) => (d.day - 1) ~/ 7;
    } else {
      labels = months;
      count = 12;
      index = (d) => d.month - 1;
    }
    planned = List.filled(count, 0);
    done = List.filled(count, 0);
    for (final day in result['days'] as List) {
      final i = index(Api.parseDay(day['day'] as String));
      planned[i] += day['planned'] as int;
      done[i] += day['done'] as int;
    }
  }

  void _showReport() {
    final days = (stats?['days'] as List?) ?? [];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: days.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Nenhuma refeição planejada neste período.'),
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const _SectionTitle('Relatório por dia'),
                  const SizedBox(height: 8),
                  ...days.map((d) {
                    final date = Api.parseDay(d['day'] as String);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'),
                      trailing: Text(
                        '${d['done']} de ${d['planned']} refeições',
                        style: TextStyle(
                          color: d['done'] == d['planned'] ? green : grayText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (error != null || stats == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildPeriodSelector(),
                Expanded(
                  child: Center(
                    child: error != null
                        ? TextButton(
                            onPressed: _load,
                            child: Text('Erro: $error\nTentar de novo',
                                textAlign: TextAlign.center),
                          )
                        : const CircularProgressIndicator(color: green),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildPeriodSelector(),
              const SizedBox(height: 20),
              _buildConsistencyCard(),
              const SizedBox(height: 24),
              _buildHistoryHeader(),
              const SizedBox(height: 12),
              _buildChartCard(),
              const SizedBox(height: 16),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              const _SectionTitle('Hábitos alimentares'),
              const SizedBox(height: 12),
              _buildHabitsCard(),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: green.withOpacity(0.22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Ver relatório completo',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Botão de voltar
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F6F7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 18,
              color: Color(0xFF1A1C1E),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Voltar',
          ),
        ),
        const SizedBox(width: 12),
        // Título
        const Expanded(
          child: Text(
            'Meu Acompanhamento',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final selected = selectedPeriod == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (selectedPeriod == index) return;
                setState(() => selectedPeriod = index);
                _load();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? green : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  periods[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : grayText,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConsistencyCard() {
    final total = stats!['planned'] as int;
    final value = total == 0 ? 0.0 : (stats!['done'] as int) / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: value.toDouble(),
                    strokeWidth: 7,
                    backgroundColor: const Color(0xFFDDF3E6),
                    valueColor: const AlwaysStoppedAnimation<Color>(green),
                  ),
                ),
                Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consistência alimentar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  total == 0
                      ? 'Nenhuma refeição planejada ${['nesta semana', 'neste mês', 'neste ano'][selectedPeriod]}'
                      : '${stats!['done']} de $total refeições feitas ${['nesta semana', 'neste mês', 'neste ano'][selectedPeriod]}',
                  style: const TextStyle(fontSize: 13, color: grayText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      children: [
        const Expanded(child: _SectionTitle('Histórico de refeições')),
        _legend(green, 'Realizadas'),
        const SizedBox(width: 10),
        _legend(trackGray, 'Planejadas'),
      ],
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: grayText)),
      ],
    );
  }

  Widget _buildChartCard() {
    final double maxValue =
        planned.fold<int>(1, (max, v) => v > max ? v : max).toDouble();
    const double chartHeight = 110;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(labels.length, (index) {
          final plannedH = planned[index] / maxValue * chartHeight;
          final doneH = done[index] / maxValue * chartHeight;

          return Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: chartHeight,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 24,
                          height: plannedH,
                          decoration: BoxDecoration(
                            color: trackGray,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Container(
                          width: 24,
                          height: doneH,
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  labels[index],
                  style: const TextStyle(fontSize: 11, color: grayText),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final s = this.stats!;
    final stats = <Map<String, dynamic>>[
      {'label': 'Refeições planejadas', 'value': '${s['planned']}', 'green': false},
      {'label': 'Refeições realizadas', 'value': '${s['done']}', 'green': true},
      {'label': 'Receitas experimentadas', 'value': '${s['recipesTried']}', 'green': false},
      {'label': 'Dias seguindo o plano', 'value': '${s['daysOnPlan']} / ${s['daysWithPlan']}', 'green': false},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 76,
      ),
      itemBuilder: (context, index) {
        final item = stats[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['label'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: grayText),
              ),
              const SizedBox(height: 6),
              Text(
                item['value'] as String,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: (item['green'] as bool) ? green : darkText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitsCard() {
    final s = stats!;
    final daysWithPlan = s['daysWithPlan'] as int;
    final donePerDay = daysWithPlan == 0 ? 0.0 : (s['done'] as int) / daysWithPlan;
    final plannedPerDay = daysWithPlan == 0 ? 0.0 : (s['planned'] as int) / daysWithPlan;
    final fruitVeg = (s['fruitVegPerDay'] as num).toDouble();
    final variety = (s['variety'] as num).toDouble();
    String fmt(double v) => v.toStringAsFixed(1).replaceAll('.', ',');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _HabitRow(
            label: 'Frequência de refeições',
            value: '${fmt(donePerDay)}/${fmt(plannedPerDay)} refeições/dia',
            progress: plannedPerDay == 0 ? 0 : (donePerDay / plannedPerDay).clamp(0, 1).toDouble(),
          ),
          const SizedBox(height: 14),
          // Meta de 5 porções de frutas/verduras por dia.
          _HabitRow(
            label: 'Frutas e verduras',
            value: '${fmt(fruitVeg)}/5 porções/dia',
            progress: (fruitVeg / 5).clamp(0, 1).toDouble(),
          ),
          const SizedBox(height: 14),
          _HabitRow(
            label: 'Variedade alimentar',
            value: s['done'] == 0
                ? '—'
                : variety >= 0.7
                    ? 'Boa'
                    : variety >= 0.4
                        ? 'Média'
                        : 'Baixa',
            progress: variety,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1C1E),
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;

  const _HabitRow({
    required this.label,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1C1E),
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF07863D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFE9EAED),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF16C768),
            ),
          ),
        ),
      ],
    );
  }
}