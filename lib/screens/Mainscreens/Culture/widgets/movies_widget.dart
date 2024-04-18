import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constant;

import '../detailswidgets/detail_movies.dart';

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({Key? key}) : super(key: key);

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  late Future<List<dynamic>> recommendationsFuture;

  @override
  void initState() {
    super.initState();
    recommendationsFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('${constant.cim}movies.php'));
    if (response.statusCode == 200) {
      final List<dynamic> recommendations = json.decode(response.body);
      return recommendations;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: recommendationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data!.map<Widget>((recommendationData) {
                return RecommendationCard(recommendationData: recommendationData);
              }).toList(),
            ),
          );
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


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRecommendScreen(idDoc: id),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 24),
       padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
            boxShadow: [
        BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      ),
      ],
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
