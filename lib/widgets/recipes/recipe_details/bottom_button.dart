import 'package:flutter/material.dart';
import 'info_chip.dart';

class BottomButton extends StatefulWidget {
  const BottomButton({super.key});

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  // 1. Declaração da variável de estado aqui
  bool isFavorite = false;
  late List<bool> checkedIngredients;

  final List<String> ingredients = [
    '2 filés de salmão (200g cada)',
    '1 batata-doce média',
    '1 xícara de brócolis',
    '2 colheres de azeite de oliva',
    'Sal e pimenta a gosto',
  ];

  @override
  Widget build(BuildContext context) {

    const Color textColor = Color(0xFF171E2E);
    const Color dividerColor = Color(0xFFE0E4E9);
    const Color primaryGreen = Color(0xFF19C45A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      color: Colors.white,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: _addToPlan,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            elevation: 5,
            shadowColor: primaryGreen.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Adicionar ao plano',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _addToPlan() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receita pronta para ser adicionada ao plano!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}