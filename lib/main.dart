import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],

      home: const MainPage(),
    );
  }
}