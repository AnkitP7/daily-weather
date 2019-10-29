import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;

  SplashScreen({this.duration});

  @override
  _SplashScreen createState() => new _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  void initState() {
    controller = new AnimationController(duration: widget.duration, vsync: this)
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (_) => new MyApp()));
        }
      });
    super.initState();
  }

  IconData iconData = const IconData(0xe100, fontFamily: 'Weather');
  final Widget svg = new SvgPicture.asset("icons/weather.svg");

  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: new AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 300.0),
              ),
              new Center(
                  child: new CircleAvatar(
                backgroundImage: new AssetImage('images/weather.gif'),
                foregroundColor: Colors.cyanAccent,
                maxRadius: 50.0,
                minRadius: 15.0,
              )),
              // new Center(
              //   child: new Icon(Icons.cloud,
              //       color: Colors.blueAccent, size: 100.0),
              // ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              new Center(
                child: new Text('Daily Weather',
                    style: new TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal)),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 150.0),
                  ),
                  new Center(
                    child: new CircularProgressIndicator(
                        backgroundColor: Colors.redAccent),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
