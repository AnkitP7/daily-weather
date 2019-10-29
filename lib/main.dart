import 'package:flutter/material.dart';
import 'package:daily_weather/backdrop.dart';
import 'dart:async';
import 'package:daily_weather/SplashScreen.dart';
import 'package:daily_weather/images.dart';
import 'package:daily_weather/Dash_weather.dart';
import 'package:daily_weather/cities.dart';
import 'package:daily_weather/info.dart';
import 'package:daily_weather/settings.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:daily_weather/weatherDashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_weather/model/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_weather/searchLocation.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  final duration = Duration(seconds: 2);

  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.black,
      home: new SplashScreen(duration: duration),
    );
  }
}

class MyApp extends StatelessWidget {
  final String apptitle = "My app";
  final String windyURL = "https://www.mywindy.com/ankit-1/weather_app";
  final String url2 = "https://www.windy.com";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          primaryColor: Colors.black),
      home: new HomePage(title: apptitle),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(title: apptitle),
        '/images': (BuildContext context) => new Images(),
        '/info': (BuildContext context) => new City(),
        "/webView": (_) => WebviewScaffold(
              url: url2,
              appBar: new AppBar(
                backgroundColor: Colors.transparent,
                title: new Text("Windy Radar"),
              ),
              withJavascript: true,
              withLocalStorage: true,
              withZoom: true,
            )
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController animation;

  List<String> citiesList = new List();
  List<WeatherModel> weatherModel = new List();
  bool isRefreshed = false;
  bool isPreserved = false;
  bool farhaneit = false;
  bool miles = false;
  bool pressure = false;
  bool precipitation = false;
  //bool onGoingNotification = false;
  String tempF;
  String tempC;
  String temp;

  // _loadData() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   citiesList = sharedPreferences.getStringList('Cities');
  //   print("Data loaded");
  // }

  // _loadPrefs() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setBool('weatherState', isPreserved);
  //   print("State set");
  // }

  void initState() {
    //getData(context);
    animation = new AnimationController(
        vsync: this, value: 1.0, duration: const Duration(milliseconds: 800));
    super.initState();
  }

  Widget get _build {
    if (isPreserved) {
      print("Serialized Data");
      return _serializedData;
    }
    print("Live data");
    return _card;
  }

  Future<List> getCities() async {
    return citiesList;
  }

  bool get _status {
    final AnimationStatus animationStatus = animation.status;
    return animationStatus == AnimationStatus.completed ||
        animationStatus == AnimationStatus.forward;
  }

  Widget get _options {
    return new ListView(
      children: <Widget>[
        new ListTile(
            leading: new AnimatedIcon(
              progress: animation.view,
              icon: AnimatedIcons.home_menu,
            ),
            title: new Text('DashBoard'),
            onTap: () {
              animation.fling(velocity: _status ? -2.0 : 2.0);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (_) => new DashWeather(weatherModel: weatherModel),
                  ));
            }),
        new ListTile(
          leading: new AnimatedIcon(
            progress: animation.view,
            icon: AnimatedIcons.search_ellipsis,
          ),
          title: new Text("Search"),
          onTap: () {
            animation.fling(velocity: _status ? -2.0 : 2.0);
            Navigator.push(context,
                new MaterialPageRoute(builder: (_) => new SearchCity()));
          },
        ),
        new ListTile(
          leading: new AnimatedIcon(
            progress: animation.view,
            icon: AnimatedIcons.list_view,
          ),
          title: new Text("Selected Cities"),
          onTap: () {
            animation.fling(velocity: _status ? -2.0 : 2.0);
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (_) => new CityList(),
                ));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.settings),
          title: new Text("Settings"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => new Settings(),
                ));
          },
        ),
        new ListTile(
          leading: new Icon(FontAwesomeIcons.ravelry),
          title: new Text("Radar"),
          onTap: () {
            Navigator.pushNamed(context, '/webView');
          },
        ),
      ],
    );
  }

  // Widget get notification{
  //   if(onGoingNotification)
  //   {
  //    String icon="http:"+weatherModel[0].icon;
  //    return new NotificationApp(icon:icon,temp: tempOptions(),description: weatherModel[0].description,showOnogingNotification: onGoingNotification);
  //   }
  //   return new NotificationApp();
  // }

  // String tempOptions() {
  //   if (farhaneit) {
  //     return weatherModel[0].tempf.toString();
  //   } else if (!farhaneit) {
  //     return weatherModel[0].tempc.toString();
  //   }
  //   return "";
  // }

  @override
  Widget build(BuildContext context) {
    try {
      //final ThemeData theme = Theme.of(context);
      //final MediaQueryData media = MediaQuery.of(context);
      //final bool centerHome =
      //  media.orientation == Orientation.portrait && media.size.height < 800.0;

      const Curve switchOutCurve =
          const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
      const Curve switchInCurve =
          const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);

      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Daily Weather"),
          leading: new Center(
              child: new Icon(Icons.cloud, color: Colors.blueAccent)),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: new Stack(
          children: <Widget>[
            new SafeArea(
              child: new BackDrop(
                backTitle: const Text("Features"),
                backLayer: _options,
                fronTitle: const Text("Cities"),
                frontAction: new AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  switchInCurve: switchInCurve,
                  switchOutCurve: switchOutCurve,
                ),
                frontLayer: new AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: switchInCurve,
                  switchOutCurve: switchInCurve,
                  child: new FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          default:
                            if (snapshot.hasError) {
                              return new Center(
                                  child: new Text("Please try again"));
                            } else if (snapshot.hasData) {
                              return _build;
                            } else {
                              return new Icon(FontAwesomeIcons.asymmetrik);
                            }
                        }
                      }),
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 20.0, left: 20.0),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e.toString());
      return new Center(child: new Text("Please try again"));
    }
  }

  // getData(BuildContext context) async {
  //   final sharedPrefs = await SharedPreferences.getInstance();
  //   if (sharedPrefs != null) {
  //     var key = sharedPrefs.getKeys();
  //     for (var keyname in key) {
  //       if (keyname.contains('Cities')) {
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             new MaterialPageRoute(builder: (_) => new Dash()),
  //             (Route<dynamic> route) => false);
  //       }
  //     }
  //   } else {
  //     Navigator.push(
  //         context, new MaterialPageRoute(builder: (_) => new SearchCity()));
  //   }
  // }

  //Options on weather -Calvin/Farhaneit

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

  //Serialized data derived from weathermodel stored in List

  Widget get _serializedData {
    try {
      return new ListView.builder(
          itemCount: citiesList.length == 0 ? 0 : citiesList.length,
          itemBuilder: (BuildContext context, int index) {
            String localtime = weatherModel[index].localtime;
            var time = localtime.split(" ");
            var finalTime = time[1];
            if (citiesList[index] == null) {
              getWeatherData(citiesList[index]);
            }
            String temp = _temperatureOptions(index);
            return new ExpansionTile(
              key: Key(index.toString()),
              leading: new Image.network('http:' + weatherModel[index].icon),
              title: new Text(weatherModel[index].cityName),
              trailing: new Text(temp,
                  softWrap: true,
                  style: new TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.w200)),
              children: <Widget>[
                new Card(
                    color: Colors.blue[400],
                    child: new SizedBox(
                      height: 200.0,
                      child: new ListView(
                        physics: new NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                          ),
                          new ListTile(
                            leading: new Text('Region'),
                            title: new Text(weatherModel[index].region),
                            subtitle: new Text(weatherModel[index].country),
                            trailing: new Text(finalTime),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.info),
                            title: new Text(weatherModel[index].description),
                          ),
                          new GridView.count(
                            key: Key(weatherModel[index].cityName),
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            childAspectRatio: 1.0,
                            children: <Widget>[
                              new ListTile(
                                leading: new Text('Max.'),
                                title: new Text(_maxTemperatureOptions(index)),
                              ),
                              new ListTile(
                                leading: new Text('Min.'),
                                title: new Text(_minTemperatureOptions(index)),
                              ),
                              new ListTile(
                                trailing: new RaisedButton.icon(
                                  label: new Text('Info'),
                                  icon: new Icon(FontAwesomeIcons.arrowRight),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (_) => new WeatherForecast(
                                                farhaneit: farhaneit,
                                                miles: miles,
                                                pressure: pressure,
                                                precipitation: precipitation,
                                                weatherModel:
                                                    weatherModel[index])));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            );
          });
    } catch (e) {
      return new Center(
          child: new Text("Something went wrong. Please try again"));
    }
  }

  //_card Widget gets Live weather

  Widget get _card {
    return new ListView.builder(
      itemCount: citiesList.length == 0 ? 0 : citiesList.length,
      itemBuilder: (BuildContext context, int index) {
        return new Stack(
          key: Key(index.toString()),
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 50.0)),
            new Container(
              child: new Stack(
                children: <Widget>[
                  new FutureBuilder<WeatherModel>(
                    future: getWeatherData(citiesList[index]),
                    builder: (BuildContext context,
                        AsyncSnapshot<WeatherModel> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.blue));
                        case ConnectionState.none:
                          return new Center(
                              child: new Text("Please check the dashboard"));
                        default:
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return new ActionChip(
                              label: new Center(
                                  child: Text("Something went wrong")),
                              onPressed: () {
                                dispose();
                              },
                            );
                          } else if ((snapshot.hasData) &&
                              (snapshot.data != null)) {
                            isPreserved = true;
                            WeatherModel model = WeatherModel();
                            model = snapshot.data;
                            weatherModel.add(model);

                            String temp;
                            if (farhaneit) {
                              temp = snapshot.data.tempf.toString() + "°F";
                            } else if (!farhaneit) {
                              temp = snapshot.data.tempc.toString() + "°C";
                            } else {
                              temp = snapshot.data.tempc.toString() + "°C";
                            }
                            String localtime = snapshot.data.localtime;
                            var time = localtime.split(" ");
                            var finalTime = time[1];
                            return new ExpansionTile(
                              key: Key(index.toString()),
                              leading: new Image.network(
                                  'http:' + snapshot.data.icon),
                              title: new Text(snapshot.data.cityName),
                              trailing: new Text(temp,
                                  softWrap: true,
                                  style: new TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w200)),
                              children: <Widget>[
                                new Card(
                                    color: Colors.blue[400],
                                    child: new SizedBox(
                                      height: 200.0,
                                      child: new ListView(
                                        physics:
                                            new NeverScrollableScrollPhysics(),
                                        children: <Widget>[
                                          new Padding(
                                            padding: const EdgeInsets.all(8.0),
                                          ),
                                          new ListTile(
                                            leading: new Text('Region'),
                                            title:
                                                new Text(snapshot.data.region),
                                            subtitle:
                                                new Text(snapshot.data.country),
                                            trailing: new Text(finalTime),
                                          ),
                                          new ListTile(
                                            leading: new Icon(Icons.info),
                                            title: new Text(
                                                snapshot.data.description),
                                          ),
                                          new GridView.count(
                                            key: Key(snapshot.data.cityName),
                                            crossAxisCount: 3,
                                            shrinkWrap: true,
                                            childAspectRatio: 1.0,
                                            children: <Widget>[
                                              new ListTile(
                                                leading: new Text('Max.'),
                                                title: new Text(snapshot
                                                    .data.maxtempC
                                                    .toString()),
                                              ),
                                              new ListTile(
                                                leading: new Text('Min.'),
                                                title: new Text(snapshot
                                                    .data.minTempC
                                                    .toString()),
                                              ),
                                              new ListTile(
                                                title: new RaisedButton.icon(
                                                  label: new Text('Info'),
                                                  icon: new Icon(
                                                      FontAwesomeIcons
                                                          .arrowRight),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (_) =>
                                                                new WeatherForecast(
                                                                    farhaneit:
                                                                        farhaneit,
                                                                    miles:
                                                                        miles,
                                                                    pressure:
                                                                        pressure,
                                                                    precipitation:
                                                                        precipitation,
                                                                    weatherModel:
                                                                        model)));
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            );
                          }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List> getData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs == null) {
      print("null");
      _error(context);
    } else {
      farhaneit = sharedPrefs.getBool('temp');
      miles = sharedPrefs.getBool('miles');
      pressure = sharedPrefs.getBool("pressure");
      precipitation = sharedPrefs.getBool("precip");
      if (farhaneit == null ||
          miles == null ||
          pressure == null ||
          precipitation == null) {
        farhaneit = false;
        miles = false;
        pressure = false;
        precipitation = false;
      }
      citiesList = sharedPrefs.getStringList('Cities');
      if (citiesList == null) {
        print("Cities null");
        _error(context);
      } else if (citiesList.length == 0) {
        print("No cities");
        _error(context);
      } else {
        print("Farhaneit => " + farhaneit.toString());
        print("Miles => " + miles.toString());
        print("Pressure => " + pressure.toString());
        print("Precipitation => " + precipitation.toString());
        // print("Ongoing Notification => " + onGoingNotification.toString());
        print(citiesList);
        print("Done");
      }
    }
    return citiesList;
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
                    leading: new Icon(
                      Icons.warning,
                      size: 50.0,
                    ),
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
} //end of class
