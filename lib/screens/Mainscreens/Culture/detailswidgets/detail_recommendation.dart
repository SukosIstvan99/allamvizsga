import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailRecommendScreen extends StatefulWidget {
  final String idDoc;

  const DetailRecommendScreen({Key? key, required this.idDoc}) : super(key: key);

  @override
  _DetailRecommendScreenState createState() => _DetailRecommendScreenState();
}

class _DetailRecommendScreenState extends State<DetailRecommendScreen> {
  late Future<List<Map<String, dynamic>>> fetchRecommendDataFuture;

  @override
  void initState() {
    super.initState();
    fetchRecommendDataFuture = fetchRecommendData(widget.idDoc);
    print('idDoc: ${widget.idDoc}');
  }

  Future<List<Map<String, dynamic>>> fetchRecommendData(String id) async {
    final response = await http.get(Uri.parse('http://192.168.1.105/user_api/detail_recommendation.php?id=$id'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> recommendations = List<Map<String, dynamic>>.from(data);
      return recommendations;
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRecommendDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final recommendedData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(recommendedData[0]['name'] ?? ''),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kulturális program részleteinek megjelenítése
                  Image.network(
                    recommendedData[0]['image1'],
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendedData[0]['name'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          recommendedData[0]['City'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          recommendedData[0]['Information'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                                child: Image.network(
                                  recommendedData[0]['image1'],
                                  width: 170,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                                child: Image.network(
                                  recommendedData[0]['image2'],
                                  width: 170,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                                child: Image.network(
                                  recommendedData[0]['image3'],
                                  width: 170,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recommendedData[0]['location'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recommendedData[0]['Phone'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Visszalépés a korábbi képernyőre
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // háttérszín
                              foregroundColor: Colors.white, // előtérszín
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
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
      },
    );
  }
}
