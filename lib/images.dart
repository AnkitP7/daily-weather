import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:daily_weather/keys/key.dart';

void main() => runApp(new Images());

class Images extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Picasso(),
      theme: new ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
      ),
    );
  }
}

class Picasso extends StatefulWidget {
  Picasso({Key key}) : super(key: key);

  _PicassoDisplay createState() => new _PicassoDisplay();
}

class _PicassoDisplay extends State<Picasso> {
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.zero,
            ),
            new DrawerHeader(
              child: new Text("The weather app"),
            ),
            new ListTile(
              title: new Text('Search'),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (_) => new MyApp(),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}

class City extends StatefulWidget {
  City({Key key, this.city, this.region, this.country, this.lat, this.long});

  final String city;
  final String region;
  final String country;
  final double lat;
  final double long;

  CityInformation createState() => new CityInformation(
      city: city, region: region, country: country, lat: lat, long: long);
}

class CityInformation extends State<City> {
  CityInformation({
    Key key,
    this.city,
    this.region,
    this.country,
    this.lat,
    this.long,
  });

  final String city;
  final String region;
  final String country;
  final double lat;
  final double long;

  List<String> images = new List();
  String cityData;

  _getURL() {
    List<String> cityList = city.split(",");
    cityData = cityList[0];
    //getPicassoImage(cityData);
  }

  void initState() {
    super.initState();
    _getURL();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        children: <Widget>[
          _picasso,
          new Container(
            child: new FutureBuilder<List>(
              future: getInfo(cityData),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.only(top: 100.0)),
                          Center(child: CircularProgressIndicator())
                        ]);
                  default:
                    if (snapshot.hasError) {
                      return new Center(
                          child: new Chip(
                              label: new Text('Try Again later',
                                  style: new TextStyle(
                                      fontSize: 15.0, fontFamily: 'Roboto'))));
                    } else if (snapshot.hasData) {
                      if ((snapshot.data.length != 0) &&
                          (snapshot.data.isNotEmpty)) {
                        return new Container(
                          padding: new EdgeInsets.only(top: 10.0),
                          child: new ListView(
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: new Card(
                                  color: Colors.transparent,
                                  child: new Text("Information",
                                      style: new TextStyle(fontSize: 40.0)),
                                ),
                              ),
                              new ListTile(
                                leading:
                                    new Icon(Icons.info_outline, size: 35.0),
                                title: new Text(snapshot.data[0].summary,
                                    style: new TextStyle(
                                        fontFamily: 'Slate',
                                        wordSpacing: 2.0,
                                        fontSize: 18.0,
                                        color: Colors.white)),
                              ),
                              // new ListTile(
                              //   leading: new Icon(Icons.link),
                              //   title: new Text(snapshot.data[0].wikipediaURL),
                              // ),
                              new ListTile(
                                leading: new Icon(Icons.location_city),
                                title: new Text(
                                    snapshot.data[0].rank.toString(),
                                    style: new TextStyle(color: Colors.white)),
                              ),
                              new ListTile(
                                leading: Icon(Icons.info),
                                title: new Card(
                                  color: Colors.transparent,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: new Text(
                                        "Information may not be accurate all the time.",
                                        style: new TextStyle(fontSize: 15.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        // return new Container(
                        //     padding: const EdgeInsets.only(top:60.0),

                        //     child: new ExpansionTile(
                        //       key: Key(snapshot.data[0].summary),
                        //       initiallyExpanded: false,
                        //       title: new Text(snapshot.data[0].summary),
                        //       children: <Widget>[
                        //       new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[new Text("City rank"),new Card(child:new Text(snapshot.data[0].rank.toString()),color: Colors.white24)]),
                        //       new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[new Chip(label: new Text(snapshot.data[0].wikipediaURL)),new IconButton(icon: Icon(Icons.launch), onPressed: (){Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("URL pressed"),));} )]),
                        //       ],
                        //     ),
                        //   );
                      } else {
                        return new Center(
                            child: new Chip(
                                label: new Text(
                          'Insufficient Data Available!',
                          style: new TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Slate',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.0),
                        )));
                      }
                    }
                }
              },
            ),
          ),
          new ListView(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.symmetric(
                  vertical: 250.0,
                  horizontal: 100.0,
                ),
              ),
              new ListTile(
                  leading: new Icon(Icons.location_city),
                  title: new Text(city,
                      style: new TextStyle(
                          fontFamily: "Rock Salt",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  onTap: () {
                    print(images);
                  }),
              new ListTile(
                leading: new Icon(Icons.local_airport),
                title: new Text(country,
                    style: new TextStyle(
                        fontFamily: "Rock Salt",
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
              new ListTile(
                leading: new Icon(Icons.place),
                title: new Text(lat.toString(),
                    style: new TextStyle(
                        fontFamily: "Rock Salt",
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
              new ListTile(
                leading: new Icon(Icons.place),
                title: new Text(long.toString(),
                    style: new TextStyle(
                        fontFamily: "Rock Salt",
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

// http.Client client=new http.Client();

  Future<Map<String, dynamic>> getPicassoImage(String name) async {
    String url = "https://pixabay.com/api/?";
    String key = "key=" + pixAPI_KEY;
    String paramValue = "&q=" + name;
    String type = "&image_type=photo";
    String orientation = "&orientation=vertical";
    String pretty = "&pretty=true";
    String finalURL = url + key + paramValue + type + orientation + pretty;
    print(finalURL);
    final response = await http.get(finalURL);
    final responseJSON = jsonDecode(response.body);
    return responseJSON;
    //return _getData(responseJSON);
  }

  // _getData(Map<String, dynamic> data) {
  //   for (var url in data['hits']) {
  //     images.add(url['largeImageURL']);
  //     return images;
  //   }
  // }

  Future<List> getInfo(String name) async {
    String url = "http://api.geonames.org/wikipediaSearchJSON?";
    String key = "&username=" + geonamesAPI_KEY;
    String max = "&maxRows=1";
    String paramValue = "&q=" + name;

    String finalURL = url + key + max + paramValue;
    print(finalURL);

    final response = await http.get(finalURL);
    final responseJSON = jsonDecode(response.body);
    print(responseJSON);
    return _getInfo(responseJSON);
  }

  _getInfo(Map<String, dynamic> data) {
    return (data['geonames'] as List).map((i) => Info.getJSON(i)).toList();
  }

  // Widget get _carousel {
  //   return new Carousel(
  //     images: [
  //       new AssetImage("images/5.jpg"),
  //       new AssetImage("images/4.jpg"),
  //       new AssetImage("images/3.jpg"),
  //     ],
  //     animationDuration: new Duration(seconds: 3),
  //     animationCurve: Curves.elasticIn,
  //     autoplay: true,
  //     boxFit: BoxFit.fill,
  //   );
  //}

  Widget get _picasso {
    return new Container(
      child: new Image.asset(
        "images/5.jpg",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}

class Info {
  String summary;
  int rank;
  String thumbnailUrl;
  String wikipediaURL;

  Info(
      {Key key, this.summary, this.rank, this.thumbnailUrl, this.wikipediaURL});

  factory Info.getJSON(Map data) {
    return new Info(
      summary: data['summary'],
      rank: data['rank'],
      thumbnailUrl: data['thumbnailImg'],
      wikipediaURL: data['wikipediaUrl'],
    );
  }
}
