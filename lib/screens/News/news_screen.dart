import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Article {
  final String title;
  final String content;
  final String date;
  final String description;
  final String imageUrl; // Hír képének URL-je

  Article({
    required this.title,
    required this.content,
    required this.date,
    required this.description,
    required this.imageUrl, // Konstruktorhoz hozzáadva
  });
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
  List<Article> articles = [
    Article(
      title: 'Cikk címe 1',
      content: 'Cikk tartalma 1',
      date: '2024-03-23',
      description: 'Rövid leírás 1',
      imageUrl: 'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', // Hír képének URL-je
    ),
    Article(
      title: 'Cikk címe 1',
      content: 'Cikk tartalma 1',
      date: '2024-03-23',
      description: 'Rövid leírás 1',
      imageUrl: 'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', // Hír képének URL-je
    ),
    Article(
      title: 'Cikk címe 1',
      content: 'Cikk tartalma 1',
      date: '2024-03-23',
      description: 'Rövid leírás 1',
      imageUrl: 'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', // Hír képének URL-je
    ),
    Article(
      title: 'Cikk címe 2',
      content: 'Cikk tartalma 2',
      date: '2024-03-24',
      description: 'Rövid leírás 2',
      imageUrl: 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', // Hír képének URL-je
    ),
    // További cikkek hozzáadása
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildArticleList(),
    );
  }

  Widget _buildArticleList() {
    return Column(
      children: [
        SizedBox(height: 70),
        Text(
          'Üdvözlünk a hírek oldalon', // Üdvözlő szöveg hozzáadása
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height:40),
        Expanded(
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hír képe
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(articles[index].imageUrl), // Hír képének URL-je
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                articles[index].title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('yMMMd').format(DateTime.parse(articles[index].date)),
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(articles[index].description),
                          SizedBox(height: 20),
                          ExpansionTile(
                            title: Text('Teljes tartalom'),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(articles[index].content),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
