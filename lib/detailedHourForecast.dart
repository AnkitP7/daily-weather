import 'package:flutter/material.dart';
import 'package:daily_weather/model/model.dart';

class DetailedHourForecast extends StatelessWidget {
  final WeatherModel weatherModel;
  final bool farhaneit, pressure, precip, miles;

  DetailedHourForecast({
    Key key,
    this.farhaneit,
    this.miles,
    this.precip,
    this.pressure,
    this.weatherModel,
  });

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: new HourForecast(
          weatherModel: weatherModel,
          farhaneit: farhaneit,
          precip: precip,
          pressure: pressure,
          miles: miles),
    );
  }
}

class HourForecast extends StatefulWidget {
  final WeatherModel weatherModel;
  final bool farhaneit, miles, pressure, precip;

  HourForecast({
    Key key,
    this.farhaneit,
    this.pressure,
    this.precip,
    this.miles,
    this.weatherModel,
  });

  _Hour createState() => new _Hour(
      weatherModel: weatherModel,
      miles: miles,
      farhaneit: farhaneit,
      precip: precip,
      pressure: pressure);
}

class _Hour extends State<HourForecast> {
  WeatherModel weatherModel;
  bool farhaneit, pressure, precip, miles;
  String temp, vision, air, press = "";

  _Hour({
    Key key,
    this.miles,
    this.farhaneit,
    this.precip,
    this.pressure,
    this.weatherModel,
  });

  String hourlyTime(int index) {
    String time = weatherModel.hour[index].time;
    List splitTime = time.split("-");
    String getTime = splitTime[2];
    List extractTime = getTime.split(" ");
    String finalTime = extractTime[1];
    return finalTime;
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

  String _windOptions(int index) {
    if (miles) {
      return air = weatherModel.hour[index].windMph.toString() + " mph";
    } else if (!miles) {
      return air = weatherModel.hour[index].windKph.toString() + " kmph";
    } else
      return air = temp;
  }

  String _visionOptions(int index) {
    if (miles) {
      return vision = weatherModel.hour[index].visionMiles.toString() + " mph";
    } else if (!miles) {
      return vision = weatherModel.hour[index].visionKM.toString() + " kmph";
    }
    return vision = temp;
  }

  String _precipitationOptions(int index) {
    if (precip) {
      return press = weatherModel.hour[index].precipMM.toString() + " mm";
    } else if (!precip) {
      return press = weatherModel.hour[index].precipIN.toString() + " in";
    }
    return press = temp;
  }

  String _pressureOptions(int index) {
    if (pressure) {
      return press = weatherModel.hour[index].pressureIN.toString() + " hg";
    } else if (!pressure) {
      return press = weatherModel.hour[index].pressureMB.toString() + " mb";
    }
    return press = temp;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("24-hour Forecast",
            style: new TextStyle(fontWeight: FontWeight.w300)),
      ),
      backgroundColor: Colors.black,
      body: new ListView.builder(
        itemCount: weatherModel.hour.length == 0 ? 0 : weatherModel.hour.length,
        itemBuilder: (BuildContext context, int index) {
          return new ExpansionTile(
            key: Key(index.toString()),
            leading: new Text(hourlyTime(index),
                style:
                    new TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0)),
            title: new ListTile(
              leading: new Image.network(
                  "http:" + weatherModel.hour[index].hourCondition.icon,
                  height: 64.0,
                  width: 64.0),
              title: new Text(hourlyOptions(index),
                  style: new TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w300)),
              subtitle: new Text(weatherModel.hour[index].hourCondition.text),
            ),
            children: <Widget>[
              _hourWeatherDetails(index),
            ],
          );
        },
      ),
    );
  }

  Widget _hourWeatherDetails(int index) {
    return new Container(
      height: 300.0,
      width: 430.0,
      child: _gridDetails(index),
    );
  }

  Widget _gridDetails(int index) {
    return new GridView.count(
      primary: false,
      physics: new NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      padding: const EdgeInsets.all(5.0),
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
                        child: new Image.asset('images/weather/clouds.png'),
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
                            weatherModel.hour[index].cloud.toString() + " %",
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300),
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
                        child: new Image.asset('images/weather/winds.png'),
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
                            _windOptions(index),
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300),
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
                        child: new Image.asset('images/weather/humidity.png'),
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
                            weatherModel.hour[index].humidity.toString() + " %",
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300),
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
                        child: new Image.asset('images/weather/pressure3.png'),
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
                            _pressureOptions(index),
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300),
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
                        child: new Image.asset('images/weather/vision.png'),
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
                            _visionOptions(index),
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300),
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
                        child: new Image.asset('images/weather/precip.png'),
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
                            _precipitationOptions(index),
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
