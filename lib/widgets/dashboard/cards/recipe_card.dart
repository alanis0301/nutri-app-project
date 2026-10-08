import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String time;
  final String calories;

  const RecipeCard({
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE1E5EB),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
                        fontWeight: FontWeight.w600,
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
