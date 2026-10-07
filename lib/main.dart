import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const NutriViverApp());
}

class NutriViverApp extends StatelessWidget {
  const NutriViverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriViver',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16C768),
        ),
      ),

      home: const MainPage(),
    );
  }
}