import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'dart:async';
import 'package:daily_weather/searchLocation.dart';

void main() => runApp(new CityList());

List<String> cities = new List();

class CityList extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.black,
      theme: new ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        primaryColor: Colors.cyan,
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MyApp(),
      },
      home: new SavedList(),
    );
  }
}

class SavedList extends StatefulWidget {
  _SavedList createState() => new _SavedList();
}

class _SavedList extends State<SavedList> {
  Future<List> getData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs == null) {
      print("null");
      _error(context);
    } else {
      cities = sharedPrefs.getStringList('Cities');
      if (cities == null) {
        print("Cities null");
        _error(context);
      } else if (cities.length == 0) {
        print("No cities");
        _error(context);
      } else {
        print(cities);
        print("Done");
      }
    }
    return cities;
  }

  GlobalObjectKey<ScaffoldState> _scaffoldState = new GlobalObjectKey("1");

  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldState,
        appBar: new AppBar(
          title: new Text('Selected cities',
              style: new TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: new Container(
          child: FutureBuilder<List>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return new Center(
                    child: new Chip(
                  label: new Text(snapshot.error.toString()),
                ));
              } else if (snapshot.hasData) {
                return new ListView.builder(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return new Dismissible(
                      dismissThresholds: _dismissable(),
                      background: Container(
                          color: Colors.blue,
                          child: new ListTile(leading: Icon(Icons.delete))),
                      secondaryBackground: Container(
                          color: Colors.blue,
                          child: new ListTile(trailing: Icon(Icons.delete))),
                      key: new Key(cities[index].toString()),
                      direction: DismissDirection.horizontal,
                      crossAxisEndOffset: -0.5,
                      onDismissed: (DismissDirection direction) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("You deleted :" + cities[index]),
                            backgroundColor: Colors.blueAccent));
                        setState(() {
                          _delete(index);
                        });
                      },
                      child: new ListTile(
                        leading: new Icon(Icons.edit_location,
                            color: Colors.white, size: 20.0),
                        title: new Text(cities[index].toString(),
                            style: new TextStyle(
                                fontFamily: 'Slate',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700)),
                        onTap: () {
                          // _scaffoldState.currentState.showSnackBar(new SnackBar(
                          //   content: new Text("Swipe left or left to discard saved cities from list"),
                          //   backgroundColor: Colors.blueAccent,
                          // ));
                          _scaffoldState.currentState
                              .showBottomSheet<Null>((BuildContext context) {
                            return new Container(
                                color: Colors.white,
                                child: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new SizedBox(
                                        child: new Card(
                                      child:
                                          new Image.asset("images/swipe.gif"),
                                    )),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: new SizedBox(
                                        child: new Card(
                                          shape: OutlineInputBorder(),
                                          color: Colors.blue,
                                          child: new Text(
                                              "Swipe left or right to discard saved places. \n Swipe down to dismiss",
                                              style: new TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          });
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.data == null) {
                return new Center(child: new Text("Cannot load cities"));
              }
            },
          ),
        ),
        drawer: new Drawer(
            child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: new Column(
                children: <Widget>[
                  new Text("Daily Weather"),
                  new CircleAvatar(
                    maxRadius: 60.0,
                    backgroundColor: Colors.blue,
                    backgroundImage:
                        new AssetImage('images/weather-app-icon.png'),
                  ),
                ],
              ),
              decoration: new BoxDecoration(
                color: Colors.blue,
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.select_all),
              title: new Text("Selected Cities"),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (_) => new MyApp(),
                    ));
              },
            ),
          ],
        )));
  }
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
                  leading: new Icon(Icons.warning, size: 50.0),
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
                    new MaterialPageRoute(builder: (_) => new Search()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        );
      });
}

void _delete(var index) async {
  cities.removeAt(index);
  final sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.setStringList('Cities', cities);
  print(cities);
  print("Updated");
}

Map<DismissDirection, double> _dismissable() {
  Map<DismissDirection, double> dismiss = new Map();
  dismiss.putIfAbsent(DismissDirection.horizontal, () => 0.5);
  return dismiss;
}
