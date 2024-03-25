import 'package:allamvizsga/screens/Culture/detailswidgets/detail_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/screens/Culture/widgets/listcard_widget.dart';
import 'package:allamvizsga/screens/Culture/widgets/recommendation_widget.dart';
import 'package:allamvizsga/screens/Culture/models/culture_models.dart';


class CultureScreen extends StatefulWidget {
  const CultureScreen({Key? key}) : super(key: key);

  @override
  _CultureScreenState createState() => _CultureScreenState();
}

class _CultureScreenState extends State<CultureScreen> {
  List<dynamic>? recommendations;
  List<dynamic>? cultures;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCultureData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.1.105/user_api/recommendation.php'));
    if (response.statusCode == 200) {
      setState(() {
        recommendations = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load recommendation data');
    }
  }

  Future<void> fetchCultureData() async {
    final response = await http.get(Uri.parse('http://192.168.1.105/user_api/listcard.php'));
    if (response.statusCode == 200) {
      setState(() {
        cultures = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load culture data');
    }
  }

  void navigateToDetailListScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailListScreen(idDoc: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommend',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recommendations?.map<Widget>((recommendationData) {
                  return RecommendationCard(recommendationData: recommendationData);
                }).toList() ?? [],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Culture Programs',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: cultures?.map<Widget>((cultureData) {
                return ListCard(
                  cultureData: cultureData,
                  onPressed: navigateToDetailListScreen,
                );
              }).toList() ?? [],
            ),
          ],
        ),
      ),
    );
  }
}
