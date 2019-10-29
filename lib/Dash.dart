import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_weather/main.dart';
import 'package:daily_weather/cities.dart';
import 'package:daily_weather/searchCity.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:daily_weather/keys/key.dart';
import 'package:transparent_image/transparent_image.dart' as transparent;

class Dash extends StatelessWidget {
  final String title = "The weather app";

  Dash({
    Key key,
  });

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: new ThemeData(brightness: Brightness.dark),
      home: new DashBoard(title: title),
    );
  }
}

class DashBoard extends StatefulWidget {
  final String title;

  DashBoard({Key key, this.title}) : super(key: key);

  @override
  _DashBoard createState() => new _DashBoard();
}

class _DashBoard extends State<DashBoard> with SingleTickerProviderStateMixin {
  TabController _tabController;
  static int count = 0;
  final List<String> pictureTags = ['football', 'flowers', 'nature'];
  static int picCount = 0;

  List<String> placesList = new List();
  _DashBoard({
    Key key,
  });

  Widget get getImage {
    return new FutureBuilder(
        future: getPicassoImage('nature+landscape'),
        builder: (context, snapshot) {
          try {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Image.asset('images/default.jpg', fit: BoxFit.fill);
              case ConnectionState.waiting:
                return new Center(child: new CircularProgressIndicator());
              // case ConnectionState.done:return _picasso;
              default:
                var imageURL;
                if (count % 2 == 0) {
                  imageURL = snapshot.data["hits"][0]["webformatURL"];
                } else {
                  imageURL = snapshot.data["hits"][1]["webformatURL"];
                }
                count++;
                if (snapshot.hasData) {
                  print(snapshot.data["hits"][0]["webformatURL"]);
                  return new FadeInImage.memoryNetwork(
                      placeholder: transparent.kTransparentImage,
                      image: imageURL,
                      height: 400.0,
                      width: 500.0,
                      fit: BoxFit.fill);
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: new Icon(Icons.cloud,
                              size: 100.0, color: Colors.blueAccent)),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[new Text('Cannot retrieve image.')],
                      )
                    ],
                  );
                } else {
                  return new Center(child: new CircularProgressIndicator());
                }
            }
          } catch (e) {
            print(e.toString());
            return new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: new Icon(Icons.cloud,
                        size: 100.0, color: Colors.blueAccent)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[new Text('Cannot retrieve image.')],
                )
              ],
            );
          }
        });
  }

  Future<Map<String, dynamic>> getPicassoImage(String name) async {
    String url = "https://pixabay.com/api/?";
    String key = "key=" + pixAPI_KEY;
    String paramValue = "&q=" + name;
    String type = "&image_type=photo&colors=black&";
    String orientation =
        "&orientation=horizontal&editors_choice=true&order=popular&safesearch=true";
    String pretty = "&pretty=true";

    String finalURL = url + key + paramValue + type + orientation + pretty;
    print(finalURL);
    final response = await http.get(finalURL);
    final responseJSON = jsonDecode(response.body);
    return responseJSON;
    //return _getData(responseJSON);
  }

  Future<List<String>> getData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs == null) {
      print("null");
      _error(context);
    } else {
      placesList = sharedPrefs.getStringList('Cities');
      if (placesList == null) {
        _error(context);
      } else if (placesList.length == 0) {
        print(placesList);
        _error(context);
      } else {
        print(placesList);
        print("Done");
      }
    }
    return placesList;
  }

  Future<Null> _error(BuildContext context) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Warning'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.error),
                    title: new Text(
                        'It appears that you have not added any preferred cities to your list'),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Go to searching cities!'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(builder: (_) => new SearchCity()),
                      (Route<dynamic> route) => false);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        title: new Text('The Weather App'),
        backgroundColor: Colors.black26,
      ),
      body: new Stack(
        children: <Widget>[
          new Card(
            elevation: 5.0,
            color: Colors.black,
            child: new SizedBox(
              height: 400.0,
              width: 500.0,
              child: getImage,
            ),
          ),
          new FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                default:
                  if (snapshot.hasError) {
                    return new Center(
                        child: new Text('Something went wrong :('));
                  } else if (snapshot.hasData) {
                    print("Fetching data");
                    return new ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: <Widget>[
                        _weather,
                      ],
                    );
                    // return new ListView(
                    //   scrollDirection: Axis.horizontal,
                    //   // physics: new NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   children: <Widget>[
                    //     _weather,
                    //   ],
                    // );
                  } else
                    return new Center(child: new Icon(Icons.warning));
              }
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: new Text('Welcome!'),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('images/3.jpg'),
                  fit: BoxFit.cover,
                ),
                color: Colors.blue,
                shape: BoxShape.rectangle,
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(
                      builder: (_) => new MyApp(),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.search),
              title: new Text('Search'),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (_) => SearchCity()));
              },
            ),
            new ListTile(
              leading: new Icon(Icons.select_all),
              title: new Text('Selected Cities'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (_) => new CityList(),
                    ));
              },
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // endDrawer: new Drawer(
      //     child: new FutureBuilder(
      //   future: getData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return _citiesList;
      //     }
      //   },
      // )),
    );
  }

  Widget get _weather {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: placesList == null ? 0 : placesList.length,
      itemBuilder: (BuildContext context, int index) {
        print(index.toString());
        return new Column(
            // scrollDirection: Axis.vertical,
            //shrinkWrap: true,
            children: <Widget>[
              new Container(
                height: 200.0,
                width: 500.0,
                child: new HomePage(),
              )
            ]);
      },
    );
  }

//   Widget get _citiesList {
//     return new ListView.builder(
//       itemCount: placesList.length == 0 ? 0 : placesList.length,
//       itemBuilder: (BuildContext context, int index) {
//         return new ListTile(
//             leading: new Icon(Icons.location_city),
//             title: new Text(placesList[index],
//                 style: new TextStyle(
//                     fontStyle: FontStyle.normal, fontWeight: FontWeight.w400)),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   new MaterialPageRoute(
//                     builder: (_) => new AllWeather(cityName: placesList[index]),
//                   ));
//             });
//       },
//     );
//   }

}
