import 'package:flutter/material.dart';

class About extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: new AboutApp(),
    );
  }
}

class AboutApp extends StatefulWidget {
  _About createState() => new _About();
}

class _About extends State<AboutApp> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("About Daily Weather"),
      ),
      body: new Container(
        child: ListView(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.apps),
              title: new Text("App Version"),
              trailing: new Text("v-1.1"),
            ),
            new ListTile(
              leading: new Icon(Icons.details),
              title: new Text("Weather data powered by"),
              trailing: new Text("APIXU"),
            ),
            new ListTile(
              leading: new Icon(Icons.high_quality),
              title: new Text("Air Quality powered by"),
              trailing: new Text("AQICN"),
            )
          ],
        ),
      ),
    );
  }
}
