import 'package:flutter/material.dart';

class MealTag extends StatelessWidget {

  final String text;

  const MealTag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color:
        Colors.white.withOpacity(0.75),

        borderRadius:
        BorderRadius.circular(7),
      ),

      child: Text(
        text,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
