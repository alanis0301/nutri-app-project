import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'recipes.dart';
import 'schedule.dart';
import 'profile.dart';

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

    // O botão "+" não troca de página.
    if (index == 2) {
      _showAddMeal();
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  void _showAddMeal() {

    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Text(
                  'Adicionar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.restaurant_menu,
                  ),
                  title: const Text(
                    'Adicionar refeição',
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    // Futuramente:
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => const AddMealPage(),
                    //   ),
                    // );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.menu_book,
                  ),
                  title: const Text(
                    'Escolher receita',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child: pages[selectedIndex],
      ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {

    const green = Color(0xFF16C768);
    const gray = Color(0xFF697386);

    return Container(

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color: Color(0xFFE1E5EB),
            width: 0.8,
          ),
        ),
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 72,

          child: Row(
            children: [

              Expanded(
                child: _buildNavigationItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Início',
                  index: 0,
                  color: green,
                ),
              ),

              Expanded(
                child: _buildNavigationItem(
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: 'Receitas',
                  index: 1,
                  color: green,
                ),
              ),

              // BOTÃO +
              SizedBox(
                width: 70,

                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _onItemTapped(2);
                    },

                    child: Container(
                      width: 52,
                      height: 52,

                      decoration: BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: green.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: _buildNavigationItem(
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_month_rounded,
                  label: 'Agenda',
                  index: 3,
                  color: green,
                ),
              ),

              Expanded(
                child: _buildNavigationItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Perfil',
                  index: 4,
                  color: green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required Color color,
  }) {
    final bool selected = selectedIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _onItemTapped(index);
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? activeIcon : icon,
                size: 22,
                color: selected
                    ? color
                    : const Color(0xFF697386),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selected
                      ? color
                      : const Color(0xFF697386),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}