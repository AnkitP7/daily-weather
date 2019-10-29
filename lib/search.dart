import 'dart:async';
import 'dart:convert';
import 'package:daily_weather/keys/key.dart';

import 'package:http/http.dart' as http;

http.Client client = new http.Client();

List cityData;

Future<List> getInfo(String data) async {
  Uri uri = new Uri.https(
      "api.apixu.com", "/v1/search.json", {"key": weatherAPI_key1, "q": data});
  print(uri);
  http.Request request = new http.Request("POST", uri);
  http.StreamedResponse response = await client.send(request);
  String information = await response.stream.transform(utf8.decoder).join();
  cityData = jsonDecode(information);
  print(cityData);
  return cityData;
}

Future<List> getSearchInfo(String data) async {
  Uri uri = new Uri.https(
      "api.apixu.com", "/v1/search.json", {"key": weatherAPI_key2, "q": data});
  print(uri.toString());
  http.Response response = await http.get(uri);
  List searchData = json.decode(response.body);
  return searchData;
}

class Search {
  List<dynamic> info;

  String id;
  String name;
  String region;
  String country;
  double lat, lon;

  Search({
    this.id,
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
  });

  factory Search.searchData(Map<String, dynamic> json) {
    return new Search(
      id: json["id"],
      name: json["name"],
      region: json["region"],
      country: json["country"],
      lat: json["lat"],
      lon: json["lon"],
    );
  }
}
