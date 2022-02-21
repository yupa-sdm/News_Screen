import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter_auth/Screens/Login/components/background.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var jsonData;
  List<ThailandNewsData> dataList = [];

  // ignore: non_constant_identifier_names
  Future<String> _GatNewsAPI() async {
    var respones = await Http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=th&apiKey=debc35fdbb4f448a89db76f6283b8082'));

    jsonData = json.decode(utf8.decode(respones.bodyBytes));
    for (var data in jsonData['articles']) {
      print(data['urlToImage']);

      if (data['urlToImage'] == null) {
        data['urlToImage'] = 'https://shorturl.asia/qnGHY';
      }
      ThailandNewsData news = ThailandNewsData(
          data['title'], data['description'], data['urlToImage']);
      dataList.add(news);
    }
    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thailand News"),
      ),
      body: Background(
        child: FutureBuilder(
          future: _GatNewsAPI(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: Image.network('${dataList[index].urlToImage}'),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          margin: EdgeInsets.all(15),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Align(
                            child: Text(
                              '${dataList[index].title}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Align(
                            child: Text(
                              '${dataList[index].description}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Container(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class ThailandNewsData {
  String title;
  String description;
  String urlToImage;
  ThailandNewsData(this.title, this.description, this.urlToImage);
}
