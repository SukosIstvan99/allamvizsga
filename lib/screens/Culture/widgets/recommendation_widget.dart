import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({Key? key}) : super(key: key);

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  late List<dynamic> recommendations;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.1.105/user_api/recommendation.php'));
    if (response.statusCode == 200) {
      setState(() {
        recommendations = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return recommendations == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final recommendationData = recommendations[index];
        if (recommendationData != null) {
          return RecommendationCard(recommendationData: recommendationData);
        } else {
          return SizedBox(); // Vagy más, amit megfelelőnek tartasz
        }
      },
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final Map<String, dynamic>? recommendationData;

  const RecommendationCard({Key? key, this.recommendationData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recommendationData == null) {
      return SizedBox(); // Vagy valamilyen placeholder widget
    }
    final String id = recommendationData!['id'] ?? '';
    final String name = recommendationData!['name'] ?? '';
    final String city = recommendationData!['city'] ?? '';
    final String image1 = recommendationData!['image1'] ?? '';

    return InkWell(
      onTap: () {
        // Add onTap action here
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 180,
              height: 170,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    image1,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
