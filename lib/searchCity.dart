import 'package:flutter/material.dart';
import 'images.dart';
import 'search.dart';
import 'dart:async';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocation/geolocation.dart';

void main() => runApp(new Search());

class Search extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new SearchCity(),
        theme: new ThemeData(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new HomePage(),
        });
  }
}

class SearchCity extends StatefulWidget {
  _SearchCity createState() => new _SearchCity();
}

class _SearchCity extends State<SearchCity> {
  TextEditingController controller = new TextEditingController();
  String city = 'Paris';
  String location;
  static int count = 1;
  List<String> citiesList;
  double lat;
  double lon;
  List<double> coord = [];
  //GlobalObjectKey _icon = new GlobalObjectKey(2);

  void initState() {
    citiesList = new List();
    super.initState();
  }

  GlobalObjectKey<ScaffoldState> _scaffoldKey = new GlobalObjectKey(1);
  Future<String> currentLocation() async {
    final GeolocationResult geolocationResult =
        await Geolocation.requestLocationPermission(const LocationPermission(
      android: LocationPermissionAndroid.fine,
      ios: LocationPermissionIOS.always,
    ));
    Stream<LocationResult> result =
        await Geolocation.currentLocation(accuracy: LocationAccuracy.best);
    LocationResult locationResult = await result.elementAt(0);
    List<Location> locationList = [];
    if (geolocationResult.isSuccessful) {
      if (locationResult.isSuccessful) {
        locationList.add(locationResult.location);
        locationList = locationResult.locations;
        lat = locationResult.location.latitude;
        lon = locationResult.location.longitude;
        print(location);
        return location = lat.toString() + "," + lon.toString();
        //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Location Retrieved"+ locationResult.location.latitude.toString())));
      } else {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text("Cannot retrieve location")));
        print(locationResult.error);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Cannot get location. Please enable location")));
    }
    return location;
  }

  Widget get getLocation {
    return new FutureBuilder<String>(
        future: currentLocation(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            default:
              if (snapshot.hasError) {
                print(snapshot.error.toString());
              } else if (snapshot.hasData) {
                String location = snapshot.data.toString();
                if (location == null) {
                  return new Center(
                      child: new Text("Cannot fetch current location"));
                }
                return new FutureBuilder(
                  future: getSearchInfo(location),
                  builder: (context, snapshot) {
                    _places(snapshot);
                  },
                );
              } else
                return new Center(child: new CircularProgressIndicator());
          }
        });
  }

  Widget _places(AsyncSnapshot snapshot) {
    return new ListView.builder(
      itemCount: snapshot.data == null ? 0 : snapshot.data.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: new Icon(Icons.place, color: Colors.white),
          trailing: new IconButton(
            highlightColor: Colors.blue,
            icon: new Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: () {
              String selected = snapshot.data[index]['name'];
              if (citiesList.length == 0) {
                citiesList.add(selected);
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text(selected + ' Added'),
                    backgroundColor: Colors.lightBlue));
                _setData();
              } else if (citiesList.contains(selected)) {
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text('You have already added ' + selected),
                    backgroundColor: Colors.blue));
                print("Duplicate detected");
              } else {
                citiesList.add(selected);
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text(selected + ' Added'),
                    backgroundColor: Colors.lightBlue));
                _setData();
                print(citiesList.length);
              }
            },
          ),
          title: new Text(
            snapshot.data[index]['name'],
            style: new TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
          onTap: () {
            String name = snapshot.data[index]['name'];
            String region = snapshot.data[index]['region'];
            String country = snapshot.data[index]['country'];
            double lat = snapshot.data[index]['lat'];
            double long = snapshot.data[index]['lon'];
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (_) => new City(
                        city: name,
                        region: region,
                        country: country,
                        lat: lat,
                        long: long)));
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Daily Weather'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 20.0,
            ),
          ),
          new ListTile(
            trailing: new Padding(
              padding: EdgeInsets.zero,
            ),
            title: _cities,
          ),
          //_locationButton,
          //  child: new Divider()
          new Container(
            constraints: new BoxConstraints.expand(
              height: 550.0,
              width: 450.0,
            ),
            child: new FutureBuilder<List>(
              future: getSearchInfo(city),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return _progress;
                  case ConnectionState.none:
                    return _error;
                  default:
                    if (snapshot.hasData) {
                      return new ListView.builder(
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return new ListTile(
                            leading: new Icon(Icons.place, color: Colors.white),
                            trailing: new IconButton(
                              highlightColor: Colors.blue,
                              icon: new Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                String selected = snapshot.data[index]['name'];
                                if (citiesList.length == 0) {
                                  citiesList.add(selected);
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(
                                          content:
                                              new Text(selected + ' Added'),
                                          backgroundColor: Colors.lightBlue));
                                  _setData();
                                } else if (citiesList.contains(selected)) {
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(
                                          content: new Text(
                                              'You have already added ' +
                                                  selected),
                                          backgroundColor: Colors.blue));
                                  print("Duplicate detected");
                                } else {
                                  citiesList.add(selected);
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(
                                          content:
                                              new Text(selected + ' Added'),
                                          backgroundColor: Colors.lightBlue));
                                  _setData();
                                  print(citiesList.length);
                                }
                              },
                            ),
                            title: new Text(
                              snapshot.data[index]['name'],
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            onTap: () {
                              _scaffoldKey.currentState.showBottomSheet<Null>(
                                  (BuildContext context) {
                                return new Container(
                                  child: new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: new Text(
                                            "Tip: Press on the + button to add location",
                                            style: new TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.w300)),
                                      ),
                                      new Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Text(
                                          "Clicking on the + button adds location to your preferred weather list.\nSwipe down or press back button to dismiss.",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      new Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Center(
                                            child: new RaisedButton.icon(
                                              shape: new StadiumBorder(),
                                              icon: Icon(Icons.location_city),
                                              label: new Text(
                                                  "Click here to get city info!"),
                                              onPressed: () {
                                                String name = snapshot
                                                    .data[index]['name'];
                                                String region = snapshot
                                                    .data[index]['region'];
                                                String country = snapshot
                                                    .data[index]['country'];
                                                double lat =
                                                    snapshot.data[index]['lat'];
                                                double long =
                                                    snapshot.data[index]['lon'];
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (_) =>
                                                            new City(
                                                                city: name,
                                                                region: region,
                                                                country:
                                                                    country,
                                                                lat: lat,
                                                                long: long)));
                                              },
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              });
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return _error;
                    } else if (snapshot.hasData == null) {
                      return _error;
                    }
                }
              },
            ),
          ),
        ],
      ),
      drawer: _getDrawer,
    );
  }

  // Widget get _locationButton {
  //   return new Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: new ListTile(
  //       leading: new Icon(FontAwesomeIcons.locationArrow),
  //       title: new Text("Get current location"),
  //       onTap: () {
  //         setState(() {});
  //       },
  //     ),
  //   );
  // }

  Widget get _cities {
    return new TextField(
      style: new TextStyle(
        fontSize: 20.0,
      ),
      controller: controller,
      autocorrect: true,
      decoration: new InputDecoration(
        fillColor: Colors.black45,
        filled: true,
        prefixIcon: _search,
        labelText: 'Search',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        hintStyle: new TextStyle(debugLabel: "Search"),
        hintText: "Search for cities via name",
      ),
      onChanged: (v) {
        setState(() {
          city = v;
        });
      },
    );
  }

  Widget get _progress {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget get _search {
    return new Icon(Icons.search, size: 50.0, color: Colors.white);
  }

  Widget get _error {
    return new Center(
      child: new Chip(
        avatar: new CircleAvatar(
          backgroundColor: Colors.redAccent,
        ),
        label: new Text("Cannot find city"),
        labelPadding: new EdgeInsets.all(10.0),
      ),
    );
  }

  // Widget get _snack {
  //   return new SnackBar(
  //     content: new Text('Click on the + button to add location.'),
  //     backgroundColor: Colors.redAccent,
  //     action: new SnackBarAction(
  //       label: 'Dismiss',
  //       onPressed: () {
  //         SnackBarClosedReason.action;
  //       },
  //     ),
  //   );
  // }

  getAddInfo() {}

  Widget get _getDrawer {
    return new Drawer(
        child: new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        new DrawerHeader(
          child: new Text('Daily weather'),
          decoration: new BoxDecoration(
            color: Colors.blue,
          ),
        ),
        new ListTile(
          leading: new Icon(Icons.home),
          title: new Text('Home'),
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(builder: (_) => new MyApp()),
                (Route<dynamic> route) => false);
          },
        ),
      ],
    ));
  }

  _setData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    //var existingCities=sharedPrefs.getStringList('Cities');
    // if(existingCities==null){
    //    sharedPrefs.setStringList('Cities', citiesList);
    //    print('New Cities List');
    // }
    // citiesList.addAll(existingCities);
    if (count == 1) {
      sharedPrefs.setBool("farhaneit", false);
      sharedPrefs.setBool("miles", false);
      sharedPrefs.setBool("pressure", false);
      sharedPrefs.setBool("precip", false);
      sharedPrefs.setStringList('Cities', citiesList);
      count = count + 1;
    }
    sharedPrefs.setStringList('Cities', citiesList);
    print("Done");
  }
}
