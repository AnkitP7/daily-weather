import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'info.dart';
import 'package:daily_weather/model/model.dart';
import 'package:daily_weather/searchCity.dart';
import 'package:daily_weather/keys/key.dart';
import 'package:transparent_image/transparent_image.dart' as transparent;
import 'package:daily_weather/main.dart';
import 'package:flutter/services.dart';
import 'package:daily_weather/settings.dart';
import 'package:daily_weather/model/imageModel.dart';
import 'package:daily_weather/jsonData/imagesJson.dart';

class DashWeather extends StatelessWidget {
  DashWeather({
    Key key,
    this.weatherModel,
  });

  final List<WeatherModel> weatherModel;

  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      theme: new ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: new Weather(weatherModel: weatherModel),
    );
  }
}

class Dashed extends StatelessWidget {
  final List<WeatherModel> weatherModel;

  Dashed({
    Key key,
    this.weatherModel,
  });

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: new Weather(weatherModel: weatherModel),
    );
  }
}

class Weather extends StatefulWidget {
  Weather({
    Key key,
    this.weatherModel,
  });

  final List<WeatherModel> weatherModel;

  _Weather createState() => new _Weather(weatherModel: weatherModel);
}

class _Weather extends State<Weather> {
  List<String> cities = new List();
  List<WeatherModel> weatherModel;
  WeatherModel city;
  String description;
  static int count = 0;

  _Weather({
    Key key,
    this.weatherModel,
  });

  bool isPreserved = false;
  bool farhaneit = false;
  bool miles = false;

  String temp;
  String tempC = " ";

  Future<List> getData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs == null) {
      print("null");
      _error(context);
    } else {
      cities = sharedPrefs.getStringList('Cities');
      farhaneit = sharedPrefs.getBool('farhaneit');

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

  String _temperatureOptions(int index) {
    if (farhaneit) {
      return temp = weatherModel[index].tempf.toString() + "°F";
    } else if (!farhaneit) {
      return temp = weatherModel[index].tempc.toString() + "°C";
    }
    return temp = tempC;
  }

  String _maxTemperatureOptions(int index) {
    if (farhaneit) {
      return temp = weatherModel[index].maxTempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp = weatherModel[index].maxtempC.toString() + "°C";
    }
    return temp = tempC;
  }

  String _minTemperatureOptions(int index) {
    if (farhaneit) {
      return temp = weatherModel[index].minTempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp = weatherModel[index].minTempC.toString() + "°C";
    }
    return temp = tempC;
  }

  void initState() {
    getData();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  Widget get _build {
    if ((isPreserved)) {
      // ((weatherModel.length == cities.length))) {
      print("Serialized Weather:Current");
      return _requestWeather;
      //return _serializedWeather;
    }
    print("Live Weather:Current");
    return _requestWeather;
  }

  var hr = DateTime.now().hour.toString();
  var min = DateTime.now().minute.toString();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        leading: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text(hr + ":" + min)),
      ),
      backgroundColor: Colors.black,
      body: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[
            new Card(
              child: new SizedBox(
                height: 400.0,
                width: 500.0,
                child: getImage,
              ),
              shape: OutlineInputBorder(),
            ),
            // new Padding(
            //   padding: const EdgeInsets.only(top:10.0),
            // ),
            new FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    default:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return new Center(
                            child: new Text(
                                "Something went wrong. Please try again"));
                      } else if (snapshot.hasData) {
                        return _build;
                      } else {
                        return new Center(
                            child: new CircularProgressIndicator());
                      }
                  }
                }),
          ],
        ),
      ),
      endDrawer: new Drawer(
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
              leading: new Icon(Icons.dashboard),
              title: new Text("Dashboard"),
              // onTap: (){
              //   Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You are on DashBoard page")));
              // },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (_) => new MyApp(),
                    ));
              },
            ),
            new ListTile(
                leading: new Icon(Icons.settings),
                title: new Text("Settings"),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (_) => new Settings(),
                      ));
                })
          ],
        ),
      ),
    );
  }

  Widget get _requestWeather {
    return new Container(
      height: 300.0,
      width: 430.0,
      child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: weatherModel.length == 0 ? 0 : weatherModel.length,
          itemBuilder: (BuildContext context, int index) {
            try {
              return new Container(
                height: 500.0,
                width: 430.0,
                child: _details(index),
              );
            } catch (e) {
              print(e.toString());
            }
          }),
    );
  }

  Widget _details(int index) {
    return new Card(
      color: Colors.transparent,
      child: new ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new ListTile(
              title: new Text(weatherModel[index].cityName,
                  style: new TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.w300)),
              subtitle: new Text(weatherModel[index].country,
                  style: new TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w400)),
              trailing: new Text(_temperatureOptions(index),
                  style: new TextStyle(
                      fontSize: 50.0, fontWeight: FontWeight.w300)),
            ),
          ),
          new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new ExpansionTile(
                key: Key(index.toString()),
                title: new Text(weatherModel[index].description,
                    style: new TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w300)),
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.maximize),
                    title: new Text(
                      _maxTemperatureOptions(index),
                      style: new TextStyle(fontSize: 25.0),
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.minimize),
                    title: new Text(_minTemperatureOptions(index),
                        style: new TextStyle(fontSize: 25.0)),
                  ),
                ],
              )),
        ],
      ),
    );
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
                      new MaterialPageRoute(builder: (_) => new SearchCity()),
                      (Route<dynamic> route) => false);
                },
              )
            ],
          );
        });
  }

  //Picasso Image

  //This Widget loads image

  Widget get getImage {
    return new FutureBuilder<ImageData>(
        future: getPicassoImage(""),
        builder: (BuildContext context, AsyncSnapshot<ImageData> snapshot) {
          try {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
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
              case ConnectionState.waiting:
                return new Center(child: new CircularProgressIndicator());
              // case ConnectionState.done:return _picasso;
              default:
                var imageURL;
                if (snapshot.hasData) {
                  if (count <= snapshot.data.imagesList.length) {
                    count++;
                    imageURL = snapshot.data.imagesList[count].webformatURL;
                    print(imageURL);
                    return new Stack(
                      children: <Widget>[
                        FadeInImage.memoryNetwork(
                          placeholder: transparent.kTransparentImage,
                          image: imageURL,
                          height: 400.0,
                          width: 500.0,
                          fit: BoxFit.fill,
                        ),
                        new Padding(
                            padding:
                                const EdgeInsets.only(top: 350.0, left: 310.0),
                            child: new Card(
                              color: Colors.transparent,
                              child: new RaisedButton.icon(
                                color: Colors.transparent,
                                icon: Icon(Icons.refresh),
                                label: new Text("Refresh"),
                                onPressed: () {
                                  setState(() {
                                    this.widget == null;
                                  });
                                },
                              ),
                            ))
                      ],
                    );
                  } else {
                    count = 0;
                  }
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
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new RaisedButton.icon(
                            color: Colors.transparent,
                            label: new Text("Refresh"),
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              setState(() {
                                this.widget == null;
                              });
                            },
                          ),
                        ],
                      ),
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
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new RaisedButton.icon(
                          color: Colors.blue,
                          label: new Text("Refresh"),
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            this.widget == null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
        });
  }

  Future<ImageData> getPicassoImage(String name) async {
    String url = "https://pixabay.com/api/?";
    String key = "key=" + pixAPI_KEY;
    String paramValue = "&q=" + name;
    //String type = "&image_type=photo&colors=black";
    String orientation =
        "&orientation=horizontal&order=popular&safesearch=true";
    String pretty = "&pretty=true";
    //editors_choice=true&

    String finalURL = url + key + paramValue + orientation + pretty;
    print(finalURL);
    final response = await http.get(finalURL);
    final responseJSON = jsonDecode(response.body);
    var data = BaseClass.fromJson(responseJSON);
    return ImageData.fromResponse(data);
  }
}

Future<List> getData() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  if (sharedPrefs == null) {
    print("null");
    //_error(context);
  } else {
    cities = sharedPrefs.getStringList('Cities');
    if (cities == null) {
      print("Cities null");
      //_error(context);
    } else if (cities.length == 0) {
      print("No cities");
      //_error(context);
    } else {
      print(cities);
      print("Done");
    }
  }
  return cities;
}
