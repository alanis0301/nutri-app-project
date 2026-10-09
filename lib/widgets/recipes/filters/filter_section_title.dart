import 'package:flutter/material.dart';
import 'package:nutri_app_project/pages/filter_recipes_page.dart';

class FilterTitle extends StatelessWidget {
  final String title;

  const FilterTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF172033),
      ),
    );
  }
}
