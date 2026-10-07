import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(

        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            _buildHeader(),

            const SizedBox(height: 24),

            _buildMetrics(),

            const SizedBox(height: 12),

            _buildNextMeal(),

            const SizedBox(height: 10),

            _buildSuggestions(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {

    return Row(
      children: [

        Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Título + Botão Filtro Lateral
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Olá, Ana!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C1E),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: Color(0xFF1A1C1E),
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    ))]);
  }

  // ==========================================================
  // MÉTRICAS
  // ==========================================================

  Widget _buildMetrics() {

    return GridView.count(

      crossAxisCount: 2,

      crossAxisSpacing: 8,
      mainAxisSpacing: 10,

      childAspectRatio: 1.65,

      shrinkWrap: true,

      physics:
      const NeverScrollableScrollPhysics(),

      children: [

        _MetricCard(
          icon: Icons.restaurant_rounded,
          iconColor: const Color(0xFF16A34A),
          iconBackground: const Color(0xFFEAF8EF),
          title: 'Refeições',
          value: '3 / 5',
        ),

        _MetricCard(
          icon:
          Icons.local_fire_department_rounded,
          iconColor: const Color(0xFFFF3B30),
          iconBackground: const Color(0xFFFFF0EF),
          title: 'Calorias',
          value: '1.250 kcal',
        ),

        _MetricCard(
          icon: Icons.adjust_rounded,
          iconColor: const Color(0xFF448AFF),
          iconBackground: const Color(0xFFEEF4FF),
          title: 'Meta Diária',
          value: '68%',
        ),

        _MetricCard(
          icon: Icons.water_drop_outlined,
          iconColor: const Color(0xFF00AEEF),
          iconBackground: const Color(0xFFEAF9FD),
          title: 'Água',
          value: '1.2L / 2L',
        ),
      ],
    );
  }

  // ==========================================================
  // PRÓXIMA REFEIÇÃO
  // ==========================================================

  Widget _buildNextMeal() {

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            const Text(
              'Próxima refeição',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172033),
              ),
            ),

            const Text(
              'Hoje às 12:30',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16C768),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius:
          BorderRadius.circular(15),

          child: SizedBox(
            height: 158,
            width: double.infinity,

            child: Stack(
              fit: StackFit.expand,

              children: [

                Image.network(
                  'https://images.unsplash.com/'
                      'photo-1540420773420-3366772f4999'
                      '?auto=format&fit=crop&w=900&q=80',

                  fit: BoxFit.cover,
                ),

                Container(
                  decoration:
                  BoxDecoration(

                    gradient:
                    LinearGradient(

                      begin:
                      Alignment.topCenter,

                      end:
                      Alignment.bottomCenter,

                      colors: [
                        Colors.transparent,
                        Colors.black
                            .withOpacity(0.70),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: [

                      Row(
                        children: [

                          _MealTag(
                            text: 'Almoço',
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          _MealTag(
                            text: '25 min',
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(
                            'Salada de Quinoa com Frango',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Rica em proteínas, fibras '
                                'e gorduras saudáveis.',

                            style: TextStyle(
                              color: Colors.white
                                  .withOpacity(0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SUGESTÕES
  // ==========================================================

  Widget _buildSuggestions() {

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(
          'Sugestões para você',

          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [

            Expanded(
              child: _RecipeCard(
                imageUrl:
                'https://images.unsplash.com/'
                    'photo-1512621776951-a57141f2eefd'
                    '?auto=format&fit=crop&w=500&q=80',

                title:
                'Bowl de Açaí Proteico',

                time: '10 min',

                calories: '320 kcal',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _RecipeCard(
                imageUrl:
                'https://images.unsplash.com/'
                    'photo-1626700051175-6818013e1d4f'
                    '?auto=format&fit=crop&w=500&q=80',

                title:
                'Wrap Integral de Atum',

                time: '12 min',

                calories: '280 kcal',
              ),
            ),
          ],
        ),
      ],
    );
  }
}


// ============================================================
// CARD DE MÉTRICA
// ============================================================

class _MetricCard extends StatelessWidget {

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String value;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
      const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(15),

        border: Border.all(
          color: const Color(0xFFE1E5EB),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(
            width: 28,
            height: 28,

            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),

          const Spacer(),

          Text(
            title,

            style: const TextStyle(
              color: Color(0xFF697386),
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,

            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// TAG
// ============================================================

class _MealTag extends StatelessWidget {

  final String text;

  const _MealTag({
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


// ============================================================
// CARD DE RECEITA
// ============================================================

class _RecipeCard extends StatelessWidget {

  final String imageUrl;
  final String title;
  final String time;
  final String calories;

  const _RecipeCard({
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: const Color(0xFFE1E5EB),
        ),
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(
            height: 96,
            width: double.infinity,

            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.all(9),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [

                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: Color(0xFF697386),
                    ),

                    const SizedBox(width: 3),

                    Text(
                      time,

                      style: const TextStyle(
                        color: Color(0xFF697386),
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(width: 7),

                    const Text(
                      '•',
                      style: TextStyle(
                        color: Color(0xFF697386),
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      calories,

                      style: const TextStyle(
                        color: Color(0xFF159447),
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}