import 'package:flutter/material.dart';

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

  // Dados de exemplo (substitua pelos dados reais)
  final List<String> days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  final List<int> planned = [4, 5, 4, 5, 4, 4, 2];
  final List<int> done = [3, 5, 3, 5, 2, 3, 1];

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
                  onPressed: () {},
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
              onTap: () => setState(() => selectedPeriod = index),
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
    const value = 0.78;

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
                    value: value,
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
              children: const [
                Text(
                  'Consistência alimentar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Última semana',
                  style: TextStyle(fontSize: 13, color: grayText),
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
    const double maxValue = 5;
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
        children: List.generate(days.length, (index) {
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
                  days[index],
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
    final plannedTotal = planned.reduce((a, b) => a + b);
    final doneTotal = done.reduce((a, b) => a + b);

    final stats = <Map<String, dynamic>>[
      {'label': 'Refeições planejadas', 'value': '$plannedTotal', 'green': false},
      {'label': 'Refeições realizadas', 'value': '$doneTotal', 'green': true},
      {'label': 'Receitas experimentadas', 'value': '8', 'green': false},
      {'label': 'Dias seguindo o plano', 'value': '5 / 7', 'green': false},
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: const [
          _HabitRow(
            label: 'Frequência de refeições',
            value: '4/5 refeições/dia',
            progress: 0.8,
          ),
          SizedBox(height: 14),
          _HabitRow(
            label: 'Frutas e verduras',
            value: '3/5 porções/dia',
            progress: 0.6,
          ),
          SizedBox(height: 14),
          _HabitRow(
            label: 'Variedade alimentar',
            value: 'Boa',
            progress: 0.88,
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