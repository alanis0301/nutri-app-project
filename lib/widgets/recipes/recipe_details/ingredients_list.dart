import 'package:flutter/material.dart';

class IngredientsList extends StatefulWidget {
  const IngredientsList({super.key});

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  final List<String> ingredients = [
    '2 filés de salmão (200g cada)',
    '1 batata-doce média',
    '1 xícara de brócolis',
    '2 colheres de azeite de oliva',
    'Sal e pimenta a gosto',
  ];

  // Declaração da lista
  late List<bool> checkedIngredients;

  // INICIALIZAÇÃO OBRIGATÓRIA PARA VARIÁVEIS LATE EM STATEFUL WIDGETS
  @override
  void initState() {
    super.initState();
    checkedIngredients = List<bool>.filled(ingredients.length, true);
  }

  @override
  Widget build(BuildContext context) {
    const Color textColor = Color(0xFF171E2E);
    const Color dividerColor = Color(0xFFE0E4E9);
    const Color primaryGreen = Color(0xFF19C45A);

    return Column(
      children: List.generate(ingredients.length, (index) {
        return Container(
          constraints: const BoxConstraints(minHeight: 43),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: checkedIngredients[index],
                  onChanged: (value) {
                    setState(() {
                      checkedIngredients[index] = value ?? false;
                    });
                  },
                  activeColor: primaryGreen,
                  checkColor: Colors.white,
                  side: const BorderSide(
                    color: primaryGreen,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  ingredients[index],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    decoration: checkedIngredients[index]
                        ? null
                        : TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}