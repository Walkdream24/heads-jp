import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  final String imagePath;
  final String? title;
  final String? date;
  final String? venue;
  final bool isMemory;

  const CarouselCard({
    Key? key,
    required this.imagePath,
    this.title,
    this.date,
    this.venue,
    this.isMemory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: isMemory ? 230 : 180,
              fit: BoxFit.cover,
            ),
          ),
          if (!isMemory) ...[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    venue ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
