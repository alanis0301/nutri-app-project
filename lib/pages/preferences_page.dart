import 'package:flutter/material.dart';

import '../services/api.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07863D);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);
  static const Color lightGreen = Color(0xFFF0FBF4);
  static const Color softGray = Color(0xFFF3F4F6);

  // Ícone por objetivo; objetivos novos no banco usam o ícone padrão.
  static const Map<String, IconData> goalIcons = {
    'Perder peso': Icons.trending_down,
    'Manter peso': Icons.show_chart,
    'Ganhar massa': Icons.workspace_premium_outlined,
    'Ter mais disposição': Icons.bolt_outlined,
  };

  // Opções vêm do backend (catálogos de goal, restriction e preference).
  List<Map<String, dynamic>> goals = [];
  List<String> restrictions = [];
  List<String> likedFoods = [];

  final Set<String> selectedGoals = {};
  final Set<String> selectedRestrictions = {};
  final Set<String> selectedLikes = {};

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// Carrega as opções e preenche a tela com o que está salvo no backend.
  Future<void> _loadProfile() async {
    try {
      final results = await Future.wait([Api.profileOptions(), Api.me()]);
      final options = results[0] as Map<String, List<String>>;
      final user = results[1] as Map<String, dynamic>;
      final names = (List list) => list.map((e) => e['name'] as String).toSet();
      if (!mounted) return;
      setState(() {
        _loading = false;
        goals = options['goals']!
            .map((g) => {'name': g, 'icon': goalIcons[g] ?? Icons.flag_outlined})
            .toList();
        restrictions = options['restrictions']!;
        likedFoods = options['preferences']!;
        selectedGoals
          ..clear()
          ..addAll(user['goal'] == null ? {} : {user['goal']['name'] as String});
        selectedRestrictions
          ..clear()
          ..addAll(names(user['restrictions']));
        final likes = names(user['preferences']);
        for (final like in likes) {
          if (!likedFoods.contains(like)) likedFoods.add(like);
        }
        selectedLikes
          ..clear()
          ..addAll(likes);
      });
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Não foi possível falar com o servidor: $e')),
    );
  }

  /// O usuário tem um único objetivo (modelo do banco), então a seleção é exclusiva.
  void _selectGoal(String value) {
    setState(() {
      selectedGoals
        ..clear()
        ..add(value);
    });
  }

  void _toggle(Set<String> set, String value) {
    setState(() {
      if (!set.remove(value)) set.add(value);
    });
  }

  Future<void> _addFood() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Adicionar alimento',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Ex: Salmão',
              hintStyle: const TextStyle(fontSize: 13, color: grayText),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: green, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: grayText),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              style: TextButton.styleFrom(foregroundColor: darkGreen),
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        if (!likedFoods.contains(result)) likedFoods.add(result);
        selectedLikes.add(result);
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await Api.updateProfile(
        goal: selectedGoals.isEmpty ? null : selectedGoals.first,
        preferences: selectedLikes.toList(),
        restrictions: selectedRestrictions.toList(),
      );
    } catch (e) {
      setState(() => _saving = false);
      _showError(e);
      return;
    }
    if (!mounted) return;
    // Retorna as preferências para a tela anterior.
    Navigator.pop(context, <String, dynamic>{
      'goals': selectedGoals.toList(),
      'restrictions': selectedRestrictions.toList(),
      'likes': selectedLikes.toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leadingWidth: 64,
        title: const Text(
          'Preferências',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: softGray,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: darkText,
                ),
              ),
            ),
          ),
        ),
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: green))
                  : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Conte mais sobre você para receber sugestões '
                          'personalizadas.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: grayText,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const _FormLabel('Objetivo'),
                    const SizedBox(height: 12),
                    ...goals.map((goal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildGoal(
                          name: goal['name'] as String,
                          icon: goal['icon'] as IconData,
                        ),
                      );
                    }),

                    const SizedBox(height: 12),
                    const _FormLabel('Restrições / Evitar'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: restrictions
                          .map((name) => _buildRestrictionChip(name))
                          .toList(),
                    ),

                    const SizedBox(height: 28),
                    const _FormLabel('Alimentos que gosto'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ...likedFoods.map((name) => _buildLikeChip(name)),
                        _buildAddChip(),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving || _loading ? null : _save,
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
                    'Salvar preferências',
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

  Widget _buildGoal({required String name, required IconData icon}) {
    final selected = selectedGoals.contains(name);

    return GestureDetector(
      onTap: () => _selectGoal(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? lightGreen : Colors.white,
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
                color: selected ? Colors.white : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected ? green : grayText,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? darkGreen : darkText,
                ),
              ),
            ),
            selected
                ? Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 15,
                color: Colors.white,
              ),
            )
                : Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestrictionChip(String name) {
    final selected = selectedRestrictions.contains(name);

    return GestureDetector(
      onTap: () => _toggle(selectedRestrictions, name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? lightGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? green : borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? darkGreen : darkText,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.cancel_outlined, size: 15, color: darkGreen),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLikeChip(String name) {
    final selected = selectedLikes.contains(name);

    return GestureDetector(
      onTap: () => _toggle(selectedLikes, name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? lightGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? green : borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? darkGreen : darkText,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_circle, size: 18, color: green),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddChip() {
    return GestureDetector(
      onTap: _addFood,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: const Color(0xFFC5CBD6)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 16, color: grayText),
              const SizedBox(width: 6),
              Text(
                'Adicionar',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: grayText,
                ),
              ),
            ],
          ),
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(20),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 4), paint);
        distance += 7;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}