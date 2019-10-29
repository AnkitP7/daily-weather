import 'package:flutter/material.dart';
import 'package:daily_weather/model/model.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:daily_weather/detailedForecast.dart';
import 'package:daily_weather/detailedHourForecast.dart';
import 'info.dart';
import 'package:flutter/services.dart';
//import 'package:transparent_image/transparent_image.dart' as transparent;

String temp,
    tempC,
    air,
    vision,
    miles,
    press,
    chancesofRain,
    chancesofSnow = " ";
GlobalKey<ScaffoldState> globalKey = new GlobalKey();

class WeatherForecast extends StatelessWidget {
  final WeatherModel weatherModel;
  final bool farhaneit;
  final bool miles;
  final bool pressure;
  final bool precipitation;

  WeatherForecast({
    Key key,
    this.weatherModel,
    this.farhaneit,
    this.miles,
    this.pressure,
    this.precipitation,
  });

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      color: Colors.black,
      home: new Forecast(
          weatherModel: weatherModel,
          farhaneit: farhaneit,
          miles: miles,
          pressure: pressure,
          precipitation: precipitation),
      theme: new ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      routes: {
        "/detailed": (_) => new Scaffold(
            body: new Detail(
                weatherModel: weatherModel,
                farhaneit: farhaneit,
                precip: precipitation,
                pressure: pressure,
                miles: miles)),
        "/detailedHour": (_) => new Scaffold(
              body: new HourForecast(
                weatherModel: weatherModel,
                farhaneit: farhaneit,
                precip: precipitation,
                pressure: pressure,
                miles: miles,
              ),
            ),
        "/webView": (_) => new WebviewScaffold(
              url: "mywindy.com/ankit-1/weather_app",
              appBar: new AppBar(
                title: new Text("Windy Radar"),
              ),
              withZoom: true,
              withLocalStorage: true,
            ),
      },
    );
  }
}

class Forecast extends StatelessWidget {
  final WeatherModel weatherModel;
  final bool farhaneit;
  final bool miles;
  final bool pressure;
  final bool precipitation;

  Forecast({
    Key key,
    this.weatherModel,
    this.farhaneit,
    this.miles,
    this.pressure,
    this.precipitation,
  });

  Widget get _build {
    if (weatherModel != null) {
      return _serializedBuild;
    }
    return new Center(child: new Text("Something went wrong"));
  }

  String _temperatureOptions() {
    if (farhaneit) {
      return temp = weatherModel.tempf.toString() + "°F";
    } else if (!farhaneit) {
      return temp = weatherModel.tempc.toString() + "°C";
    }
    return temp = tempC;
  }

  String _windOptions() {
    if (miles) {
      return air = weatherModel.windmph.toString() + " mph";
    } else if (!miles) {
      return air = weatherModel.windkph.toString() + " kmph";
    } else
      return air = tempC;
  }

  String _visionOptions() {
    if (miles) {
      return vision = weatherModel.visionMiles.toString() + " mph";
    } else if (!miles) {
      return vision = weatherModel.visionKM.toString() + " kmph";
    }
    return vision = tempC;
  }

  String _avgTemperatureOptions() {
    if (farhaneit) {
      return temp = weatherModel.avgTempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp = weatherModel.avgTempC.toString() + "°C";
    }
    return temp = tempC;
  }

  String _avgWindOptions() {
    if (miles) {
      return air = weatherModel.maxWindMph.toString() + " mph";
    } else if (!miles) {
      return air = weatherModel.maxWindKph.toString() + " kmph";
    }
    return air;
  }

  String _avgVisionOptions() {
    if (miles) {
      return vision = weatherModel.avgVisM.toString() + " mph";
    } else if (!miles) {
      return vision = weatherModel.avgVisKM.toString() + " kmph";
    }
    return vision;
  }

  String _pressureOptions() {
    if (pressure) {
      return press = weatherModel.pressurein.toString() + " hg";
    } else if (!pressure) {
      return press = weatherModel.pressuremb.toString() + " mb";
    }
    return press = tempC;
  }

  String _precipitationOptions() {
    if (precipitation) {
      return press = weatherModel.precipmm.toString() + " mm";
    } else if (!precipitation) {
      return press = weatherModel.precipin.toString() + " in";
    }
    return press = tempC;
  }

  String _totalPrecipitationOptions() {
    if (precipitation) {
      return press = weatherModel.totalPrecipMM.toString() + " mm";
    } else if (!precipitation) {
      return press = weatherModel.totalPrecipIN.toString() + " in";
    }
    return press = tempC;
  }

  String _feelsLikeOptions() {
    if (farhaneit) {
      return temp = weatherModel.faranheit.toString() + "°F";
    } else if (!farhaneit) {
      return temp = weatherModel.centrigade.toString() + "°C";
    } else {
      return temp;
    }
  }

  String hourlyOptions(int index) {
    if (farhaneit) {
      return temp = weatherModel.hour[index].tempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp = weatherModel.hour[index].tempC.toString() + "°C";
    } else {
      return temp;
    }
  }

  String chancesOfRain(int index) {
    if (weatherModel.hour[index].chanceOfRain != "0") {
      return chancesofRain = weatherModel.hour[index].chanceOfRain + "%";
    } else {
      return chancesofRain = " ";
    }
  }

  String chancesOfSnow(int index) {
    if (weatherModel.hour[index].chanceOfSnow != "0") {
      return chancesofSnow = weatherModel.hour[index].chanceOfSnow + "%";
    } else {
      return chancesofSnow = " ";
    }
  }

  String hourlyTime(int index) {
    String time = weatherModel.hour[index].time;
    List splitTime = time.split("-");
    String getTime = splitTime[2];
    List extractTime = getTime.split(" ");
    String finalTime = extractTime[1];
    return finalTime;
  }

  Widget get _serializedBuild {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                "http:" + weatherModel.icon,
                height: 164.0,
                width: 160.0,
                //scale: 100.0,
              ),
              new Padding(
                  padding: new EdgeInsets.only(top: 70.0),
                  child: new SizedBox(
                    width: 250.0,
                    child: new Text(weatherModel.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w300)),
                  )),
            ]),
        new Container(
          padding: new EdgeInsets.only(left: 20.0),
          child: new ListTile(
            title: new Text(_temperatureOptions(),
                style: new TextStyle(color: Colors.white, fontSize: 45.0)),
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: new ListTile(
            leading: new Icon(Icons.location_city),
            title: new Text(weatherModel.cityName,
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Slate',
                    fontWeight: FontWeight.w600)),
            subtitle: new Text(weatherModel.region,
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontFamily: 'Slate',
                    fontWeight: FontWeight.w400)),
          ),
        ),
        new Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0),
            child: new Text("Details",
                style: new TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300))),
        new Container(
          height: 300.0,
          width: 600.0,
          child: new GridView.count(
            primary: false,
            physics: new NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(30.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 20.0,
            children: <Widget>[
              new Container(
                  color: Colors.black,
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new Stack(
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child:
                                  new Image.asset('images/weather/clouds.png'),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Clouds'),
                              ],
                            ),
                            new Spacer(
                              flex: 1,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  weatherModel.cloud.toString() + " %",
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              new Container(
                  color: Colors.black,
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new Stack(
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child:
                                  new Image.asset('images/weather/winds.png'),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Winds'),
                              ],
                            ),
                            new Spacer(
                              flex: 1,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  _windOptions(),
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              new Container(
                  color: Colors.black,
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new Stack(
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: new Image.asset(
                                  'images/weather/humidity.png'),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Humidity'),
                              ],
                            ),
                            new Spacer(
                              flex: 1,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  weatherModel.humidity.toString() + " %",
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              new Container(
                  color: Colors.black,
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new Stack(
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: new Image.asset(
                                  'images/weather/pressure3.png'),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Pressure'),
                              ],
                            ),
                            new Spacer(
                              flex: 1,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  _pressureOptions(),
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              new Container(
                  color: Colors.black,
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new Stack(
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child:
                                  new Image.asset('images/weather/vision.png'),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Visibility'),
                              ],
                            ),
                            new Spacer(
                              flex: 1,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  _visionOptions(),
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              new Container(
                  color: Colors.black,
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new Stack(
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child:
                                  new Image.asset('images/weather/precip.png'),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Precipitation'),
                              ],
                            ),
                            new Spacer(
                              flex: 1,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  _precipitationOptions(),
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: new Text('Feels like',
                style: new TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w300))),
        new Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: new Card(
            child: new SizedBox(
              height: 100.0,
              width: 600.0,
              child: _feel,
            ),
          ),
        ),
        _forecast,

        // new Padding(
        //   padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        //   child: new ListTile(
        //     title: new Text("24-hour Forecast",
        //         style:
        //             new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
        //     trailing: new Icon(Icons.navigate_next),
        //     onTap: () {
        //       Navigator.pushNamed(globalKey.currentContext, '/detailedHour');
        //     },
        //   ),
        // ),
        // new Padding(
        //   padding: const EdgeInsets.only(left: 20.0, top: 10.0),
        //   child: new SizedBox(
        //     height: 150.0,
        //     width: double.infinity,
        //     child: _hourlyForecast,
        //   ),
        // ),
        new Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0),
          child: new ListTile(
            title: Text(
              'Forecast',
              style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pushNamed(globalKey.currentContext, '/detailed');
            },
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 25.0),
          child: new Text("Overview",
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10.0),
          child: new SizedBox(
            height: 150.0,
            width: double.infinity,
            child: _serializedForecast,
          ),
        ),
        new Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: new Text("Timeline",
                style: new TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w300))),
        // new Padding(
        //   padding: const EdgeInsets.only(left: 20.0),
        //   child: new SizedBox(
        //     height: 50.0,
        //     width: double.infinity,
        //     child: _timeline,
        //   ),
        // ),
        new Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 10.0),
          child: new Text(
            "Maximum and minimum weather chart forecast",
            style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
          child: new Column(
            children: <Widget>[
              _maxWeatherLine,
              _minWeatherLine,
            ],
          ),
        ),
        //WeatherLine
        new Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
          child: new Text('Air Quality Index',
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
        ),
        new SizedBox(
          height: 130.0,
          width: 600.0,
          child: _airIndex,
        ),

        //WindDirection
        new Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0),
          child: new Text("Wind information",
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
        ),
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: _windDirection,
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0),
          child: new Text('Astro',
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 20.0),
          child: _sun,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: _moon,
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
          child: new Center(
            child: new Text("POWERED BY DAILY WEATHER",
                style:
                    new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w200)),
          ),
        )
        // new Padding(
        //   padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        //   child: new Text("Radar",
        //       style:
        //           new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
        // ),
        //Radar
        //_radarFullView(),
      ],
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      backgroundColor: Colors.black,
      body: _build,
    );
  }

  Widget get _feel {
    if (weatherModel.isDay == 1) {
      return new DecoratedBox(
        child: new ListTile(
          trailing: new Card(
            color: Colors.transparent,
            child: new Text(_feelsLikeOptions(),
                style: new TextStyle(fontSize: 30.0)),
          ),
        ),
        decoration: new BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/weather/day1.png'),
                fit: BoxFit.cover)),
      );
    }
    return new DecoratedBox(
      child: new ListTile(
        trailing: new Card(
          color: Colors.transparent,
          child: new Text(_feelsLikeOptions(),
              style: new TextStyle(fontSize: 30.0)),
        ),
      ),
      decoration: new BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/weather/night.png'), fit: BoxFit.cover),
      ),
    );
  }

  //Forecast
  Widget get _forecast {
    return new Container(
      width: 500.0,
      height: 550.0,
      padding: new EdgeInsets.only(top: 10.0),
      child: new ListView(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: new Text("Forecast for today",
                  style: new TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w300))),
          new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Image.network(
                  "http:" + weatherModel.forecastIcon,
                  height: 164.0,
                  width: 160.0,
                  //scale: 100.0,
                ),
                new Padding(
                    padding: new EdgeInsets.only(top: 70.0),
                    child: new SizedBox(
                      width: 280.0,
                      child: new Text(weatherModel.forecastDescription,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w300)),
                    ))
              ]),
          new Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20.0),
              child: new Container(
                  height: 300.0,
                  width: 600.0,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 20.0,
                    children: <Widget>[
                      new Container(
                          child: new SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: new Stack(
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: new Image.asset(
                                      'images/weather/avgTemp.png'),
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text('Avg. Temperature'),
                                  ],
                                ),
                                new Spacer(
                                  flex: 1,
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      _avgTemperatureOptions(),
                                      style: new TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                      new Container(
                          color: Colors.black,
                          child: new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: new Stack(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: new Image.asset(
                                          'images/weather/maxWind.png'),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text('Max. Wind'),
                                      ],
                                    ),
                                    new Spacer(
                                      flex: 1,
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          _avgWindOptions(),
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      new Container(
                          color: Colors.black,
                          child: new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: new Stack(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: new Image.asset(
                                          'images/weather/avgHumidity.png'),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text('Avg. Humidity'),
                                      ],
                                    ),
                                    new Spacer(
                                      flex: 1,
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          weatherModel.avgHumidity.toString() +
                                              " %",
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      new Container(
                          color: Colors.black,
                          child: new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: new Stack(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: new Image.asset(
                                          'images/weather/avgVision.png'),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text('Avg. Visibility'),
                                      ],
                                    ),
                                    new Spacer(
                                      flex: 1,
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          _avgVisionOptions(),
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      new Container(
                          color: Colors.black,
                          child: new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: new Stack(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: new Image.asset(
                                          'images/weather/dewpoint.png'),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text('Total precip.'),
                                      ],
                                    ),
                                    new Spacer(
                                      flex: 1,
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          _totalPrecipitationOptions(),
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                //UV
                              ],
                            ),
                          )),
                      new Container(
                          color: Colors.black,
                          child: new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: new Stack(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: new Image.asset(
                                          'images/weather/uv.png'),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text('UV'),
                                      ],
                                    ),
                                    new Spacer(
                                      flex: 1,
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          weatherModel.uv.toString(),
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ))),
        ],
      ),
    );
  }

//Astro-sun

  Widget get _sun {
    return new Container(
      child: new SizedBox(
          height: 100.0,
          width: 500.0,
          child: new Column(
            children: <Widget>[
              new ListTile(
                leading: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: new Image.asset('images/weather/sunrise.png'),
                        )
                      ],
                    ),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text('Sunrise',
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.yellow,
                                fontWeight: FontWeight.w300))
                      ],
                    ),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(weatherModel.sunrise,
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ],
                ),
                trailing: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: new Image.asset('images/weather/sunset.png'),
                        )
                      ],
                    ),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text('Sunset',
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.yellow,
                                fontWeight: FontWeight.w300))
                      ],
                    ),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(weatherModel.sunset,
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  String _forecastTempOptions(int index) {
    if (farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.maxtempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.maxtempC.toString() + "°C";
    }
    return temp = tempC;
  }

  String _forecastMinOptions(int index) {
    if (farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.mintempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.mintempC.toString() + "°C";
    }
    return temp = tempC;
  }

  Widget get _serializedForecast {
    return new ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: weatherModel.forecastWeather.length == 0
          ? 0
          : weatherModel.forecastWeather.length,
      itemBuilder: (BuildContext context, int index) {
        try {
          String finalURL = "http:" +
              weatherModel.forecastWeather[index].day.forecastCondition.icon;
          //print(finalURL);
          String date = weatherModel.forecastWeather[index].date;
          List dateSplit = date.split("-");
          //print(dateSplit[2]);
          String finalDate = dateSplit[2] + '/' + dateSplit[1];
          return new Stack(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.all(8.0),
              ),
              new Card(
                color: Colors.transparent,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(left: 10.0)),
                    new Row(
                      children: <Widget>[
                        new Text(
                          _forecastTempOptions(index),
                          style: new TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                    new Row(children: <Widget>[
                      new SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: new Image.network(finalURL))
                    ]),
                    new Row(
                      children: <Widget>[
                        new Text(_forecastMinOptions(index),
                            style: new TextStyle(fontSize: 15.0)),
                      ],
                    ),
                    new Divider(
                      color: Colors.white,
                    ),
                    new Row(children: <Widget>[
                      new Card(child: new Text(finalDate))
                    ]),
                  ],
                ),
              ),
            ],
          );
        } catch (e) {
          print("Error occured while loading serialized forecast");
        }
      },
    );
  }

  Widget get _timeline {
    return new ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: weatherModel.forecastWeather.length == 0
          ? 0
          : weatherModel.forecastWeather.length,
      itemBuilder: (BuildContext context, int index) {
        String date = weatherModel.forecastWeather[index].date;
        List dateSplit = date.split("-");
        //print(dateSplit[2]);
        String finalDate = dateSplit[2] + '/' + dateSplit[1];
        return new Stack(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
            ),
            new Card(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text(finalDate),
                  ],
                )
              ],
            )),
          ],
        );
      },
    );
  }

  //Air Quality
  Widget get _airIndex {
    if (_airQuality != null)
      return _airQuality;
    else
      return new Center(
          child: new Text("Data not availabe",
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)));
  }

  Widget get _airQuality {
    return new FutureBuilder(
      future: getAirForecast(weatherModel.lat, weatherModel.lon),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        try {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
            case ConnectionState.none:
              return new Center(
                  child: new Text("Data not availabe",
                      style: new TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w400)));
            default:
              if (snapshot.hasError) {
                return new Center(child: new Text('Data not available'));
              } else if (snapshot.hasData) {
                int aqi = snapshot.data["data"]["aqi"];
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: _pollutionLevel(aqi)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                      child: _airQualitySlider(aqi),
                      // child: new SliderTheme(
                      //   child: _airQualitySlider(aqi),
                      //   data: new SliderThemeData(
                      //     valueIndicatorShape: RoundSliderThumbShape(),
                      //     valueIndicatorColor: Colors.red,
                      //     overlayColor: Colors.transparent,
                      //     disabledActiveTickMarkColor: Colors.grey,
                      //     disabledActiveTrackColor: Colors.yellow,
                      //     thumbColor: Colors.red,
                      //     thumbShape: RoundSliderThumbShape(),
                      //     disabledInactiveTickMarkColor: Colors.red,
                      //     disabledInactiveTrackColor: Colors.amber,
                      //     disabledThumbColor: Colors.grey,
                      //     activeTickMarkColor: Colors.red,
                      //     activeTrackColor: Colors.red,
                      //     showValueIndicator:
                      //         ShowValueIndicator.onlyForContinuous,
                      //     inactiveTickMarkColor: Colors.red,
                      //     valueIndicatorTextStyle: TextStyle(color: Colors.red),
                      //     inactiveTrackColor: Colors.grey,
                      //   ),
                      // ),
                    ),
                  ],
                );
              }
          }
        } catch (e) {
          return new Center(child: new Text('Data not available'));
        }
      },
    );
  }

  Widget _airQualitySlider(int aqi) {
    return new Slider(
        min: 0.0,
        max: 350.0,
        divisions: 6,
        value: double.parse(aqi.toString()),
        onChanged: (double v) {});
  }

  Widget _pollutionLevel(int aqi) {
    if ((aqi >= 0) && (aqi < 50)) {
      return new ListTile(
        leading: new Text(aqi.toString(),
            style: new TextStyle(color: Colors.grey, fontSize: 70.0)),
        title: new Text("Good",
            style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                color: Colors.grey)),
        subtitle:
            new Text('Air quality is considered satisfactory', maxLines: 3),
      );
    } else if ((aqi >= 50) && (aqi <= 100)) {
      return new ListTile(
        leading: new Text(aqi.toString(),
            style: new TextStyle(color: Colors.yellow, fontSize: 70.0)),
        title: new Text("Moderate",
            style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                color: Colors.yellow)),
        subtitle: new Text('Air quality is acceptable'),
      );
    } else if ((aqi >= 100) && (aqi <= 150)) {
      return new ListTile(
        leading: new Text(aqi.toString(),
            style: new TextStyle(color: Colors.orange, fontSize: 70.0)),
        title: new Text("Unhealthy for sensitive groups",
            style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                color: Colors.orange)),
        subtitle: new Text(
            'Members of sensitive groups may experience health effects. General public is not likely to be affected',
            maxLines: 3),
      );
    } else if ((aqi >= 150) && (aqi <= 200)) {
      return new ListTile(
          leading: new Text(aqi.toString(),
              style: new TextStyle(color: Colors.red, fontSize: 70.0)),
          title: new Text("Unhealthy",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.red)),
          subtitle:
              new Text('Everyone may begin to experience health effects'));
    } else if ((aqi >= 200) && (aqi < 300)) {
      return new ListTile(
          leading: new Text(aqi.toString(),
              style: new TextStyle(color: Colors.purple, fontSize: 70.0)),
          title: new Text("Very Unhealthy",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.purple)),
          subtitle: new Text(
              'Health warnings of emergency conditions. The entire population is more likely to be affected',
              maxLines: 2));
    }
    return new ListTile(
        leading: new Text(aqi.toString(),
            style: new TextStyle(color: Colors.brown, fontSize: 70.0)),
        title: new Text("Hazardous",
            style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                color: Colors.brown)),
        subtitle: new Text(
            'Health alert: everyone may experience more serious health effects'));
  }

  Widget get _moon {
    return new Container(
      child: new SizedBox(
          height: 200.0, //Change height when required
          width: 400.0,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(top: 10.0),
                //child: _moontile,
              ),
              // new Padding(
              //   padding: const EdgeInsets.only(top: 20.0),
              //   child: _moonDetails,
              // ),
              new Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: new ListTile(
                  leading: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child:
                                new Image.asset('images/weather/moonrise.png'),
                          )
                        ],
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text('Moonrise',
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.w300))
                        ],
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(weatherModel.moonrise,
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ],
                  ),
                  trailing: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child:
                                new Image.asset('images/weather/moonset.png'),
                          )
                        ],
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text('Moonset',
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.w300))
                        ],
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text(weatherModel.moonset,
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _moonPhases(String phase) {
    if (phase == "First Quarter") {
      return new Image.asset("images/moon_phases/firstQuarter.png");
    } else if (phase == "Last Quarter") {
      return new Image.asset("images/moon_phases/lastQuarter.png");
    } else if (phase == "Waning Gibbous") {
      return new Image.asset("images/moon_phases/waningGibbous.png");
    } else if (phase == "Waxing Gibbous") {
      return new Image.asset("images/moon_phases/waxingGibbous.png");
    } else if (phase == "Waning Crescent") {
      return new Image.asset("images/moon_phases/waningCrescent.png");
    } else if (phase == "Waxing Crescent") {
      return new Image.asset("images/moon_phases/waxingCrescent.png");
    } else if (phase == "Full Moon") {
      return new Image.asset("images/moon_phases/fullMoon.png");
    } else
      return new Text("NA");
  }

  Widget get _moontile {
    return new Container(
        child: new Column(
      children: <Widget>[
        new Column(
          children: <Widget>[
            new ListTile(
              leading: new Text("Moon today",
                  style: new TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w300)),
              trailing: new SizedBox(
                height: 70.0,
                width: 70.0,
                child: _moonPhases(weatherModel.moonPhase),
              ),
            )
          ],
        )
      ],
    ));
  }

  Widget get _moonDetails {
    return new Container(
        child: new SizedBox(
      child: new ListTile(
        leading: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new SizedBox(
                  height: 50.0,
                  width: 50.0,
                )
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text('Moon Phase',
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.yellow,
                        fontWeight: FontWeight.w300))
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(weatherModel.moonPhase,
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
              ],
            ),
          ],
        ),
        trailing: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new SizedBox(
                  height: 50.0,
                  width: 50.0,
                )
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text('Moon Illumination',
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.yellow,
                        fontWeight: FontWeight.w300))
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(weatherModel.moonIllumination + "%",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
              ],
            )
          ],
        ),
      ),
    ));
  }

  List<double> minimumWeather() {
    List<double> minWeather = new List();
    for (var i = 0; i < weatherModel.forecastWeather.length; i++) {
      if (farhaneit) {
        minWeather.add(weatherModel.forecastWeather[i].day.mintempF);
      } else {
        minWeather.add(weatherModel.forecastWeather[i].day.mintempC);
      }
    }
    return minWeather;
  }

  List<double> maximumWeather() {
    List<double> maxWeather = new List();
    for (var i = 0; i < weatherModel.forecastWeather.length; i++) {
      if (farhaneit) {
        maxWeather.add(weatherModel.forecastWeather[i].day.maxtempF);
      } else {
        maxWeather.add(weatherModel.forecastWeather[i].day.maxtempC);
      }
    }
    return maxWeather;
  }

  Widget get _minWeatherLine {
    return new Container(
      child: new Sparkline(
        data: minimumWeather(),
        lineColor: Colors.redAccent,
        pointsMode: PointsMode.all,
        pointColor: Colors.white,
        pointSize: 5.0,
        fillColor: Colors.white10,
        fillMode: FillMode.above,
      ),
    );
  }

  Widget get _maxWeatherLine {
    return new Container(
      child: new Sparkline(
        data: maximumWeather(),
        lineColor: Colors.blueAccent,
        pointsMode: PointsMode.all,
        pointColor: Colors.white,
        pointSize: 5.0,
        fillColor: Colors.white10,
        fillMode: FillMode.below,
      ),
    );
  }

  //Wind direction

  Widget get _windDirection {
    String direction = _widDir(weatherModel.windDirection);
    if (direction == null) {
      direction = "NA";
    }
    return new SizedBox(
      child: new Card(
        color: Colors.black,
        child: new ListTile(
            leading: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("Wind Degree"),
                new Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: new Text(
                      weatherModel.winddegree.toString(),
                      style: new TextStyle(fontSize: 20.0),
                    )),
              ],
            ),
            trailing: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      _windOptions(),
                      style: new TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      direction,
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget get forecast {
    return new Container(
      child: new ListView.builder(
        shrinkWrap: true,
        itemCount: weatherModel.forecastWeather.length == 0
            ? 0
            : weatherModel.forecastWeather.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListView(
            children: <Widget>[
              new ListTile(
                title: new Text(weatherModel
                    .forecastWeather[index].day.forecastCondition.text),
              )
            ],
          );
        },
      ),
    );
  }

  Widget get _hourlyForecast {
    return new ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: weatherModel.hour.length == 0 ? 0 : weatherModel.hour.length,
      itemBuilder: (BuildContext context, int index) {
        try {
          String finalURL =
              "http:" + weatherModel.hour[index].hourCondition.icon;
          print(finalURL);
          return new Card(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Card(
                      child: new Row(
                        children: <Widget>[
                          new Text(hourlyOptions(index),
                              style: new TextStyle(fontSize: 15.0)),
                        ],
                      ),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(chancesOfRain(index),
                        style: new TextStyle(color: Colors.blue)),
                  ],
                ),
                new Row(children: <Widget>[
                  new SizedBox(
                      height: 60.0,
                      width: 60.0,
                      child: new Image.network(finalURL))
                ]),
                new Row(
                  children: <Widget>[
                    new Text(chancesOfSnow(index),
                        style: new TextStyle(color: Colors.cyan))
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(hourlyTime(index),
                        style: new TextStyle(fontSize: 15.0)),
                  ],
                )
              ],
            ),
          );
        } catch (e) {
          print("Error ocurred while loading hourly forecast");
        }
      },
    );
  }

  // Widget get _image {
  //   return new Card(
  //     child: new SizedBox(height: 400.0, width: 500.0, child: _unsplashImage),
  //     shape: OutlineInputBorder(),
  //   );
  // }

  // Widget get _unsplashImage {
  //   return new FutureBuilder<Map<String,dynamic>>(
  //       future: getRandomPhoto(),
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         try {
  //           switch (snapshot.connectionState) {
  //             case ConnectionState.none:
  //               return new Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   Center(
  //                       child: new Icon(Icons.cloud,
  //                           size: 100.0, color: Colors.blueAccent)),
  //                   new Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[new Text('Cannot retrieve image.')],
  //                   )
  //                 ],
  //               );
  //             case ConnectionState.waiting:
  //               return new Center(child: new CircularProgressIndicator());
  //             // case ConnectionState.done:return _picasso;
  //             default:
  //               if (snapshot.hasData) {
  //                 String imageURL = snapshot.data['urls']['regular'];
  //                 return new Stack(
  //                   children: <Widget>[
  //                     FadeInImage.memoryNetwork(
  //                       placeholder: transparent.kTransparentImage,
  //                       image: imageURL,
  //                       height: 400.0,
  //                       width: 500.0,
  //                       fit: BoxFit.fill,
  //                     ),
  //                   ],
  //                 );
  //               } else if (snapshot.hasError) {
  //                 print(snapshot.error);
  //                 return new Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: <Widget>[
  //                     Center(
  //                         child: new Icon(Icons.cloud,
  //                             size: 100.0, color: Colors.blueAccent)),
  //                     new Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[new Text('Cannot retrieve image.')],
  //                     ),
  //                     // new Row(
  //                     //   mainAxisAlignment: MainAxisAlignment.center,
  //                     //   crossAxisAlignment: CrossAxisAlignment.start,
  //                     //   children: <Widget>[
  //                     //     new RaisedButton.icon(
  //                     //       color: Colors.transparent,
  //                     //       label: new Text("Refresh"),
  //                     //       icon: Icon(Icons.refresh),
  //                     //       onPressed: () {
  //                     //         setState(() {
  //                     //           this.widget == null;
  //                     //         });
  //                     //       },
  //                     //     ),
  //                     //   ],
  //                     // ),
  //                   ],
  //                 );
  //               } else {
  //                 return new Center(child: new CircularProgressIndicator());
  //               }
  //           }
  //         } catch (e) {
  //           print(e.toString());
  //           return new Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Center(
  //                   child: new Icon(Icons.cloud,
  //                       size: 100.0, color: Colors.blueAccent)),
  //             ],
  //           );
  //         }
  //       });
  // }
  //Radar webView
  // final _webViewPlugin=new FlutterWebviewPlugin();
  // final String windyURL="mywindy.com/ankit-1/weather_app";
  // _radar(){
  //   _webViewPlugin.launch(
  //     windyURL,
  //     rect: new Rect.fromLTWH(
  //       0.0, 0.0, 430.0, 300.0)
  //   );
  // }

  // void dispose(){
  //   _webViewPlugin.dispose();
  // }

  // Widget _radarFullView(){
  //   return new Center(
  //     child: new RaisedButton.icon(
  //       icon: new Icon(Icons.arrow_forward),
  //       label: new Text("Radar"),
  //       onPressed: (){
  //         _webViewPlugin.launch("www.google.com");
  //       },
  //     ),
  //   );
  // }

}

String _widDir(String dir) {
  switch (dir) {
    case "N":
      return "North";
    case "S":
      return "South";
    case "E":
      return "East";
    case "W":
      return "West";
    case "NE":
      return "North East";
    case "NW":
      return "North West";
    case "SE":
      return "South East";
    case "SW":
      return "South West";
    case "ENE":
      return "East North East";
    case "NNE":
      return "North North East";
    case "ESE":
      return "East South East";
    case "SSE":
      return "South South East";
    case "SSW":
      return "South South West";
    case "WSW":
      return "West South West";
    case "WNW":
      return "West North West";
    case "NNW":
      return "North North West";
    default:
      return dir;
  }
}

// Widget get _sunAstro {
//   return Padding(
//     padding: EdgeInsets.all(10.0),
//     child: Column(
//       children: <Widget>[
//         Expanded(
//           child: Align(
//             alignment: FractionalOffset.center,
//             child: AspectRatio(
//               aspectRatio: 1.0,
//               child: Stack(
//                 children: <Widget>[
//                   Positioned.fill(
//                     child: new CustomPaint(
//                       painter: new Painter(),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }
