import 'package:daily_weather/jsonData/json.dart';

class ForecastModel {
  List<ForecastWeather> forecastWeather = new List();

  ForecastModel({this.forecastWeather});

  ForecastModel.fromResponse(BaseClass base)
      : forecastWeather = base.forecast.forecastWeather.toList();
}
