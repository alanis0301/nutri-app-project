import 'package:flutter/material.dart';
import 'navigation_item.dart';

class BottomNavigationBard extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigationBard({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16C768);

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
                child: NavigationItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Início',
                  index: 0,
                  selectedIndex: selectedIndex,
                  color: green,
                  onTap: onItemTapped,
                ),
              ),

              Expanded(
                child: NavigationItem(
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: 'Receitas',
                  index: 1,
                  selectedIndex: selectedIndex,
                  color: green,
                  onTap: onItemTapped,
                ),
              ),

              // BOTÃO +
              SizedBox(
                width: 70,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      onItemTapped(2); // Aciona o índice 2 (Abrir modal AddMeal)
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
                child: NavigationItem(
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_month_rounded,
                  label: 'Agenda',
                  index: 3,
                  selectedIndex: selectedIndex,
                  color: green,
                  onTap: onItemTapped,
                ),
              ),

              Expanded(
                child: NavigationItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Perfil',
                  index: 4,
                  selectedIndex: selectedIndex,
                  color: green,
                  onTap: onItemTapped,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}