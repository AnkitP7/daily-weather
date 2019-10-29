import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedBack extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: new FeedBackHome(),
    );
  }
}

class FeedBackHome extends StatefulWidget {
  _FeedBackHome createState() => new _FeedBackHome();
}

class _FeedBackHome extends State<FeedBackHome> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Feedback"),
      ),
      backgroundColor: Colors.black,
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.rate_review),
              title: new Text("Rate the app"),
              onTap: () {
                _launchURL();
              },
            ),
            new ListTile(
              leading: new Icon(Icons.comment),
              title: new Text("Suggestions/advice"),
              onTap: () {
                _launchEmail();
              },
            ),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const playURL =
        "https://play.google.com/store/apps/details?id=com.ankit.dailyweather";
    if (await canLaunch(playURL)) {
      await launch(playURL);
    } else {
      throw "Oops! Something went wrong.";
    }
  }

  _launchEmail() async {
    const gmailURL =
        "mailto:ankit.patel39@gmail.com?subject=Daily Weather:App Feedback";
    if (await canLaunch(gmailURL)) {
      await launch(gmailURL);
    } else {
      throw "Oops! Something went wrong";
    }
  }
}
