import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final Map<String, dynamic> cultureData;
  final Function(String) onPressed;
  // Módosítás

  const ListCard({Key? key, required this.cultureData, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cultureData == null) {
      return SizedBox(); // Vagy valamilyen placeholder widget
    }
    final String id = cultureData!['id'] ?? '';
    return InkWell(
      onTap: () {
        onPressed(id); // Módosítás: id átadása a callback-nek
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.only(
                right: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    cultureData['image1'] ?? 'https://via.placeholder.com/150',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cultureData['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    cultureData['city'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
