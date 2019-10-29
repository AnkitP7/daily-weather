import 'package:flutter/material.dart';
import 'images.dart';
import 'search.dart';
import 'dart:async';
import 'main.dart';
import 'package:daily_weather/settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocation/geolocation.dart';
//import 'package:location/location.dart';

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
  //String city = 'Paris';
  String cityName;
  String location;
  static int count = 1;
  List<String> citiesList;
  double lat;
  double lon;
  bool locationClicked = false;
  bool manualEntry = false;
  bool requested = false;
  GeolocationResult geoLocationresult;
  StreamSubscription<LocationResult> streamSubscription;
  LocationResult locationResult;
  String finalLocation;

  void initState() {
    citiesList = new List();
    super.initState();
  }

  GlobalObjectKey<ScaffoldState> _scaffoldKey = new GlobalObjectKey(1);

  checkGps() async {
    final GeolocationResult permissionResult =
        await Geolocation.isLocationOperational();
    if (permissionResult.isSuccessful) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> currentLocation() async {
    String text = "";
    try {
      geoLocationresult =
          await Geolocation.requestLocationPermission(const LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ));
      if (requested && geoLocationresult.isSuccessful && mounted) {
        setState(() {
          streamSubscription = Geolocation.currentLocation(
                  accuracy: LocationAccuracy.best, inBackground: true)
              .listen((result) {
            var location;
            location = result;
            setState(() {
              locationResult = location;
              lat = locationResult.location.latitude;
              lon = locationResult.location.longitude;
              finalLocation = lat.toString() + "," + lon.toString();
              //return finalLocation;
            });
          });
        });

        streamSubscription.onDone(() => setState(() {
              requested = false;
              // if (locationResult.location != null) {
              //   lat = locationResult.location.latitude;
              //   lon = locationResult.location.longitude;
              //   print(lat.toString());
              //   print(lon.toString());
              //   finalLocation = lat.toString() + "," + lon.toString();

              //return finalLocation;
              _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(content: new Text("Location Retrieved")));
              //}
            }));
      } else {
        switch (geoLocationresult.error.type) {
          case GeolocationResultErrorType.runtime:
            text = 'Failure: ${geoLocationresult.error.message}';
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(text)));
            break;
          case GeolocationResultErrorType.locationNotFound:
            text = 'Location not found';
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(text)));
            break;
          case GeolocationResultErrorType.serviceDisabled:
            text = 'Service disabled. Please enable location';
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(text)));
            break;
          case GeolocationResultErrorType.permissionDenied:
            text = 'Permission denied';
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(text)));
            break;
          case GeolocationResultErrorType.playServicesUnavailable:
            text =
                'Play services unavailable: ${geoLocationresult.error.additionalInfo}';
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(text)));
            break;
          default:
            text =
                "Please check whether you have enabled location and try again";
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(text)));
            break;
        }
        //locationResult = null;
        streamSubscription = null;
        //streamSubscription.cancel();
      }
    } catch (e) {
      print("Location exception");
      print(e.toString());
      //return finalLocation;
    }
    return finalLocation;
  }

  _build() {
    if (locationClicked) {
      return new FutureBuilder<String>(
          future: currentLocation(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              default:
                if (snapshot.hasError) {
                  return new Center(
                      child: new Text(
                          "Cannot retrieve location. Please search manually"));
                } else if (snapshot.hasData) {
                  return _citiesData(snapshot.data);
                } else {
                  return new Container(
                    height: 0.0,
                    width: 0.0,
                  );
                }
            }
          });
    } else if (manualEntry) {
      return _citiesData(cityName);
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Daily Weather'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: new Container(
        child: new ListView(
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
            new Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: new ListTile(
                leading: new Icon(FontAwesomeIcons.locationArrow, size: 20.0),
                title: new Text("Current location",
                    style: new TextStyle(fontSize: 20.0)),
                onTap: () {
                  setState(() {
                    locationClicked = true;
                    requested = true;
                    manualEntry = false;
                  });
                },
              ),
            ),
            new Container(
                child: new Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: _build(),
            ))
          ],
        ),
      ),
      drawer: _getDrawer,
    );
  }

  Widget _citiesData(String cityName) {
    return new Container(
      //  height: 400.0,
      //  width: 430.0,
      child: FutureBuilder<List>(
        future: getSearchInfo(cityName),
        builder: (context, snapshot) {
          try {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(child: _progress);
              case ConnectionState.none:
                return _error;
              default:
                if (snapshot.hasData) {
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
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                      content: new Text(selected + ' Added'),
                                      backgroundColor: Colors.lightBlue));
                              _setData();
                            } else if (citiesList.contains(selected)) {
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                      content: new Text(
                                          'You have already added ' + selected),
                                      backgroundColor: Colors.blue));
                              print("Duplicate detected");
                            } else {
                              citiesList.add(selected);
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
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
                          _scaffoldKey.currentState
                              .showBottomSheet<Null>((BuildContext context) {
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
                                      "Clicking on the + button adds location to your preferred weather list.\nAdd multiple cities on one go \nSwipe down or press back button to dismiss.",
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
                                            String name =
                                                snapshot.data[index]['name'];
                                            String region =
                                                snapshot.data[index]['region'];
                                            String country =
                                                snapshot.data[index]['country'];
                                            double lat =
                                                snapshot.data[index]['lat'];
                                            double long =
                                                snapshot.data[index]['lon'];
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
          } catch (e) {
            print("Cities list failed");
            return new Container();
          }
        },
      ),
    );
  }

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
          //city = v;
          manualEntry = true;
          locationClicked = false;
          _build();
          cityName = v;
        });
      },
      onSubmitted: (v) {
        setState(() {
          manualEntry = true;
          locationClicked = false;
          _build();
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
  //     content: new Text('Already added.'),
  //     backgroundColor: Colors.redAccent,
  //     action: new SnackBarAction(
  //       label: 'Duplicate',
  //       onPressed: () {
  //         SnackBarClosedReason.action;
  //       },
  //     ),
  //   );
  // }

  Widget get _getDrawer {
    return new Drawer(
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
                backgroundImage: new AssetImage('images/weather-app-icon.png'),
              )
            ],
          ),
          decoration: new BoxDecoration(
            color: Colors.blue,
          ),
        ),
        new ListTile(
          leading: new Icon(Icons.search),
          title: new Text("Search"),
        ),
        new Divider(),
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
        )
      ],
    ));
  }

  _setData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    // var existingCities=sharedPrefs.getStringList('Cities');
    // if(existingCities==null){
    //    sharedPrefs.setStringList('Cities', citiesList);
    //    print('New Cities List');
    // }
    // else{
    // citiesList.addAll(existingCities);}
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
