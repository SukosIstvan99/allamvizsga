import 'package:allamvizsga/screens/Mainscreens/Culture/detailswidgets/detail_culture.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/screens/Mainscreens/Culture/widgets/culture_widget.dart';
import 'package:allamvizsga/screens/Mainscreens/Culture/widgets/movies_widget.dart';
import 'package:allamvizsga/screens/Mainscreens/Culture/models/culture_models.dart';
import 'package:allamvizsga/network/constants.dart' as constants;


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
    final response = await http.get(Uri.parse('${constants.cim}movies.php'));
    if (response.statusCode == 200) {
      setState(() {
        recommendations = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load recommendation data');
    }
  }

  Future<void> fetchCultureData() async {
    final response = await http.get(Uri.parse('${constants.cim}culture.php'));
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
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mozi',
              style:const TextStyle(
                fontFamily: 'Graduate',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
              'Kulturális Programok',
              style: TextStyle(
                fontFamily: 'Graduate',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
            SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
