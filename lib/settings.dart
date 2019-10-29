import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_weather/feedback.dart';
import 'package:daily_weather/about.dart';
import 'dart:async';

bool miles = false;
bool farhaneit = false;
bool pressure = false;
bool precipitation = false;

class SettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.black,
      theme: new ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
      ),
      home: new Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  _Settings createState() => new _Settings();
}

class _Settings extends State<Settings> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text("Units"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (_) => new TempUnits(),
                  ));
            },
          ),
          new ListTile(
            title: new Text("FeedBack"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (_) => new FeedBack(),
                  ));
            },
          ),
          new ListTile(
            title: new Text("About"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (_) => new About(),
                  ));
            },
          )
        ],
      ),
    );
  }
}

class TempUnits extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.black,
      theme: new ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: new Units(),
    );
  }
}

class Units extends StatefulWidget {
  _Units createState() => new _Units();
}

class _Units extends State<Units> with TickerProviderStateMixin {
  List<bool> isValue = new List();

  Key tempKey = new Key('temp');
  Key distanceKey = new Key('distance');

  Future<List<bool>> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    farhaneit = preferences.getBool('temp');
    print("Stored Preferences:Miles => " + miles.toString());
    miles = preferences.getBool('miles');
    print("Stored Prefrences:Farhaneit => " + farhaneit.toString());
    pressure = preferences.getBool('pressure');
    print("Stored Preferences:Pressure => " + pressure.toString());
    precipitation = preferences.getBool("precip");
    print("Stored Preferences:Precipitation => " + precipitation.toString());
    if ((farhaneit != null) &&
        (miles != null) &&
        (pressure != null) &&
        (precipitation != null)) {
      return isValue;
    } else {
      farhaneit = false;
      miles = false;
      pressure = false;
      precipitation = false;
      isValue.add(farhaneit);
      isValue.add(miles);
      isValue.add(pressure);
      isValue.add(precipitation);
      return isValue;
    }
    //print("Done");
    //return isValue;
  }

  setTempValue(bool value) async {
    setState(() {
      farhaneit = value;
    });
    //farhaneit=value;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Temp =>" + farhaneit.toString());
    preferences.setBool("temp", farhaneit);
    print("Temp Value set");
  }

  setDistanceValue(bool value) async {
    setState(() {
      miles = value;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Miles =>" + miles.toString());
    preferences.setBool("miles", miles);
    print("Distance value set");
  }

  setPressureValue(bool value) async {
    setState(() {
      pressure = value;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Pressure =>" + pressure.toString());
    preferences.setBool("pressure", pressure);
    print("Pressure value set");
  }

  setPrecipitationValue(bool value) async {
    setState(() {
      precipitation = value;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Preciptation =>" + precipitation.toString());
    preferences.setBool("precip", precipitation);
    print("Precipitation value set");
  }

  Widget get _values {
    return new FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: new SizedBox(
                height: 400.0,
                width: 430.0,
                child: _options(farhaneit, miles, pressure, precipitation),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return new Text("Something went wrong.");
          } else {
            return new Text("Something went wrong.! ");
          }
        });
  }

  Widget _options(
      bool farhaneit, bool miles, bool pressure, bool precipitation) {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new SwitchListTile(
          key: tempKey,
          title: new Text("Farhaneit"),
          activeColor: Colors.blueGrey,
          value: farhaneit,
          onChanged: (bool value) {
            setTempValue(value);
          },
          secondary: new Icon(FontAwesomeIcons.thermometerFull),
          subtitle: new Text(
              "By default weather is displayed in Celsius.\nTurn 'ON' to display in Farhaneit"),
        ),
        new SwitchListTile(
          title: new Text("Miles"),
          activeColor: Colors.blueGrey,
          value: miles,
          onChanged: (bool value) {
            setDistanceValue(value);
          },
          secondary: new Icon(FontAwesomeIcons.road),
          subtitle: new Text(
              "By default vision,wind and humidity is displayed in KiloMeters.\nTurn 'ON' to display in miles"),
        ),
        new SwitchListTile(
          title: new Text("Pressure"),
          activeColor: Colors.blueGrey,
          value: pressure,
          onChanged: (bool value) {
            setPressureValue(value);
          },
          secondary: new Icon(FontAwesomeIcons.solidArrowAltCircleDown),
          subtitle: new Text(
              "By default Pressure is displayed in milibar.\nTurn 'ON' to display in hga"),
        ),
        new SwitchListTile(
          title: new Text("Precipitation"),
          activeColor: Colors.blueGrey,
          value: precipitation,
          onChanged: (bool value) {
            setPrecipitationValue(value);
          },
          secondary: new Icon(FontAwesomeIcons.cloud),
          subtitle: new Text(
              "By default Precipitation is displayed in inches.\nTurn 'ON' to display in mm"),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Units"),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: new Column(
          children: <Widget>[
            _values,
          ],
        ));
  }
}
