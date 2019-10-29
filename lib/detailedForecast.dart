import 'package:flutter/material.dart';
import 'package:daily_weather/model/model.dart';

class DetailedForecast extends StatelessWidget {
  final WeatherModel weatherModel;
  final bool farhaniet, precip, pressure, miles;

  DetailedForecast({
    Key key,
    this.weatherModel,
    this.farhaniet,
    this.miles,
    this.precip,
    this.pressure,
  });

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
      ),
      home: new Detail(
          weatherModel: weatherModel,
          farhaneit: farhaniet,
          precip: precip,
          pressure: precip,
          miles: miles),
    );
  }
}

class Detail extends StatefulWidget {
  final WeatherModel weatherModel;
  final bool farhaneit, miles, precip, pressure;

  Detail({
    Key key,
    this.weatherModel,
    this.farhaneit,
    this.pressure,
    this.precip,
    this.miles,
  });

  _Detail createState() => new _Detail(
      weatherModel: weatherModel,
      miles: miles,
      precipitation: precip,
      pressure: pressure,
      farhaneit: farhaneit);
}

class _Detail extends State<Detail> {
  WeatherModel weatherModel;
  bool farhaneit, miles, pressure, precipitation;
  String temp, vision, air, press, tempC = "";

  _Detail({
    this.weatherModel,
    this.miles,
    this.precipitation,
    this.pressure,
    this.farhaneit,
  });

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Forecast for next few days",
            style: new TextStyle(fontWeight: FontWeight.w300)),
        backgroundColor: Colors.black,
      ),
      body: new Container(
        child: new ListView.builder(
          itemCount: weatherModel.forecastWeather.length == 0
              ? 0
              : weatherModel.forecastWeather.length,
          itemBuilder: (BuildContext context, int index) {
            String date = weatherModel.forecastWeather[index].date;
            List dateSplit = date.split("-");
            //print(dateSplit[2]);
            String finalDate = dateSplit[2] + '/' + dateSplit[1];
            return new ExpansionTile(
              key: Key(index.toString()),
              leading: new Image.network(
                  "http:" +
                      weatherModel
                          .forecastWeather[index].day.forecastCondition.icon,
                  scale: 1.0),
              title: new Text(finalDate +
                  " - " +
                  weatherModel
                      .forecastWeather[index].day.forecastCondition.text),
              backgroundColor: Colors.black,
              children: <Widget>[
                new Card(
                  color: Colors.transparent,
                  child: new SizedBox(
                    height: 200.0,
                    width: 450.0,
                    child: new ListView(
                      physics: new NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                          child: new Text(
                            "Temperature",
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            new Row(
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 15.0),
                                  child: Text("Avg."),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 15.0),
                                  child: Text(
                                    _avgTemperatureOptions(index),
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Row(
                                      children: <Widget>[
                                        new Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 15.0),
                                          child: Text("Min."),
                                        ),
                                        new Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 15.0),
                                          child: Text(
                                            _minTemperatureOptions(index),
                                            style:
                                                new TextStyle(fontSize: 20.0),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 15.0),
                                      child: Text("Max."),
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 15.0),
                                      child: Text(
                                        _maxTemperatureOptions(index),
                                        style: new TextStyle(fontSize: 20.0),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                          child: new Text("Precipitation",
                              style: new TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w300)),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 15.0),
                              child: new Text("Total Precipitation"),
                            ),
                            new Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 15.0),
                              child: new Text(_totalPrecipitationOptions(index),
                                  style: new TextStyle(fontSize: 20.0)),
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                          child: new Text("Winds",
                              style: new TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w300)),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 15.0),
                                  child: Text("Max. Winds"),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 15.0),
                                  child: Text(
                                    _maxwindOptions(index),
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _maxTemperatureOptions(int index) {
    if (farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.maxtempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.maxtempC.toString() + "°C";
    }
    return temp = tempC;
  }

  String _minTemperatureOptions(int index) {
    if (farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.mintempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.mintempC.toString() + "°C";
    }
    return temp = tempC;
  }

  String _maxwindOptions(int index) {
    if (miles) {
      return air =
          weatherModel.forecastWeather[index].day.maxWindMph.toString() +
              " mph";
    } else if (!miles) {
      return air =
          weatherModel.forecastWeather[index].day.maxWindKph.toString() +
              " kmph";
    } else
      return air = tempC;
  }

  String _avgTemperatureOptions(int index) {
    if (farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.avgtempF.toString() + "°F";
    } else if (!farhaneit) {
      return temp =
          weatherModel.forecastWeather[index].day.avgtempC.toString() + "°C";
    }
    return temp = tempC;
  }

  String _totalPrecipitationOptions(int index) {
    if (precipitation) {
      return press =
          weatherModel.forecastWeather[index].day.totalPrecipMM.toString() +
              " mm";
    } else if (!precipitation) {
      return press =
          weatherModel.forecastWeather[index].day.totalPrecipIN.toString() +
              " in";
    }
    return press = tempC;
  }
}
