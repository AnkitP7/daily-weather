import 'package:daily_weather/model/model.dart';
import 'package:daily_weather/jsonData/json.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

String key = "";
Future<WeatherModel> getWeatherData(String city) async {
  Uri uri = new Uri.https(
      "api.apixu.com", "v1/forecast.json", {"key": key, "q": city});
  print(uri);
  final response = await http.get(uri);
  final responseJson = json.decode(response.body);
  print(responseJson);
  var data = BaseClass.fromJson(responseJson);
  print(data);
  return WeatherModel.fromResponse(data);
}
