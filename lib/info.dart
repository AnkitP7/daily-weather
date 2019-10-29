import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daily_weather/keys/key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_weather/jsonData/json.dart';
import 'package:daily_weather/model/model.dart';
import 'package:daily_weather/model/forecastModel.dart';

http.Client httpClient = new http.Client();

Future<Map<String, dynamic>> getWeatherInfo(String city) async {
  Uri uri = new Uri.https(
      "api.apixu.com", "/v1/current.json", {"key": weatherAPI_key2, "q": city});
  print(uri);
  final response = await http.get(uri);
  final responseJson = json.decode(response.body);
  //print(responseJson);
  print("Weather model");
  return responseJson;
}

Future<Map<String, dynamic>> getForecastInfo(String city) async {
  Uri uri = new Uri.https(
      "api.apixu.com", "v1/forecast.json", {"key": weatherAPI_key2, "q": city});
  print(uri);
  final response = await http.get(uri);
  final responseJson = json.decode(response.body);
  print(responseJson);
  return responseJson;
}

List<String> cities = new List();

Future<bool> _getData() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  if (sharedPrefs == null) {
    print("null");
    return false;
  } else {
    cities = sharedPrefs.getStringList('Cities');
    if (cities == null) {
      print("Cities null");
      return false;
    } else if (cities.length == 0) {
      print("No cities");
      return false;
    } else {
      print(cities);
      return true;
    }
  }
}

Future<WeatherModel> getWeatherData(String city) async {
  Uri uri = new Uri.https("api.apixu.com", "v1/forecast.json",
      {"key": weatherAPI_key2, "q": city, "days": "10"});
  print(uri);
  final response = await http.get(uri);
  final responseJson = json.decode(response.body);
  print(responseJson);
  var data = BaseClass.fromJson(responseJson);
  cacheData(data);
  return WeatherModel.fromResponse(data);
}

BaseClass data;

cacheData(BaseClass base) {
  data = base;
}

getWeather() async {
  var check = _getData();
  if (check == true) {
    WeatherModel weatherModel = WeatherModel.fromResponse(data);
    return weatherModel;
  } else {
    String city = cities[0] != null ? cities[0] : cities[1];
    Future<WeatherModel> weather = getWeatherData(city);
    return weather;
  }
}

Future<ForecastModel> getForecast(String cityName) async {
  Uri uri = new Uri.https("api.apixu.com", "v1/forecast.json",
      {"key": weatherAPI_key1, "q": cityName, "days": "10"});
  final response = await http.get(uri);
  print(uri);
  final jsonResponse = jsonDecode(response.body);
  var data = BaseClass.fromJson(jsonResponse);
  print(data);
  return ForecastModel.fromResponse(data);
}

Future<Map<String, dynamic>> getAirForecast(double lat, double lon) async {
  Uri uri = new Uri.https(
      "api.waqi.info",
      "feed/geo:" + lat.toString() + ";" + lon.toString() + "/",
      {"token": airAPIKEY});
  final response = await http.get(uri);
  print(uri);
  final jsonResponse = jsonDecode(response.body);
  print(jsonResponse);
  return jsonResponse;
}

Future<Map<String, dynamic>> getRandomPhoto() async {
  Uri uri = new Uri.https(
      "api.unsplash.com", "/photos/random/", {"client_id": accessKey});
  final response = await http.get(uri);
  print(uri);
  final photoResponse = jsonDecode(response.body);
  print(photoResponse);
  return photoResponse;
}
