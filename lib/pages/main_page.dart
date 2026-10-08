import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'recipes.dart';
import 'schedule.dart';
import 'profile.dart';
import '../widgets/main_page/add_meal.dart';
import '../widgets/main_page/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int selectedIndex = 0;

  final List<Widget> pages = [
    const DashboardPage(),
    const RecipesPage(),
    const SizedBox(),
    const SchedulePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      showModalBottomSheet(
        context: context,
        builder: (context) => const AddMeal(),
      );
      return;
    }
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pages[selectedIndex],
      ),

      bottomNavigationBar: BottomNavigationBard(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

}