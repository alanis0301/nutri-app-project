import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'recipes.dart';
import 'agenda_page.dart';
import 'profile.dart';
import 'add_to_plan_page.dart';
import '../widgets/main_page/add_meal.dart';
import '../widgets/main_page/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const int recipesTab = 1;
  static const int agendaTab = 3;

  int selectedIndex = 0;

  // Muda a key ao voltar de "Adicionar ao plano" para a aba recarregar os dados.
  int reloadCount = 0;

  Future<void> _openAddMeal() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => const AddMeal(),
    );
    if (!mounted) return;
    if (choice == AddMeal.addMeal) {
      final added = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const AddToPlanPage()),
      );
      if (added == true) setState(() => reloadCount++);
    } else if (choice == AddMeal.chooseRecipe) {
      setState(() => selectedIndex = recipesTab);
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _openAddMeal();
      return;
    }
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(onOpenAgenda: () => _onItemTapped(agendaTab)),
      const RecipesPage(),
      const SizedBox(),
      const AgendaPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: SafeArea(
        child: KeyedSubtree(
          key: ValueKey('$selectedIndex-$reloadCount'),
          child: pages[selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBard(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
