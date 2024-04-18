import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constant;

class Article {
  final String title;
  final String content;
  final String date;
  final String description;
  final String imageUrl;

  Article({
    required this.title,
    required this.content,
    required this.date,
    required this.description,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }
}

class NewsScreen extends StatefulWidget {
  final String title;

  NewsScreen({
    Key? key,
    this.title = 'Valami',
  }) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse("${constant.cim}news.php"));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildArticleList(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }


  Widget _buildArticleList(List<Article> articles) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          'News',
          style: TextStyle(
            fontFamily: 'Graduate',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 70),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(articles[index].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            articles[index].title ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DateFormat('yyyy-MM-dd').format(DateTime.parse(articles[index].date)),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            articles[index].description ?? '',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          ExpansionTile(
                            title: Text(
                              'Teljes tartalom',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  articles[index].content ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
