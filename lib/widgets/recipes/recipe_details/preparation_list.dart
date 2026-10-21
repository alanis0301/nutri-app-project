import 'package:flutter/material.dart';
import 'info_chip.dart';

class PreparationList extends StatefulWidget {
  final List<String> steps;

  const PreparationList({super.key, required this.steps});

  @override
  State<PreparationList> createState() => _PreparationListState();
}

class _PreparationListState extends State<PreparationList> {
  // 1. Declaração da variável de estado aqui
  late final List<String> preparationSteps = widget.steps;

  @override
  Widget build(BuildContext context) {
    const Color textColor = Color(0xFF171E2E);
    const Color darkGreen = Color(0xFF128442);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: List.generate(preparationSteps.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F8EE),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    preparationSteps[index],
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}