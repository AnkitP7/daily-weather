import 'package:daily_weather/jsonData/json.dart';

class WeatherModel {
  final String cityName;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String localtime;

  final double windmph;
  final double windkph;
  final int winddegree;
  final int cloud;
  final double pressuremb;
  final double pressurein;
  final double precipmm;
  final double precipin;
  final int humidity;
  final double centrigade;
  final double faranheit;
  final double tempc;
  final double tempf;
  final double visionKM;
  final double visionMiles;
  final String description;
  final String icon;
  final String windDirection;
  // final String text;

  final double maxtempC;
  final double minTempC;
  final double maxTempF;
  final double minTempF;
  final int isDay;

  final double avgTempC;
  final double avgTempF;
  final double maxWindKph;
  final double maxWindMph;
  final double totalPrecipMM;
  final double totalPrecipIN;
  final double avgVisKM;
  final double avgVisM;
  final double avgHumidity;
  final double uv;

  final String forecastDescription;
  final String forecastIcon;

  List<ForecastWeather> forecastWeather = new List();
  List<Hour> hour = new List();
  //HourCondition hourCondition;

  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;
  final String moonIllumination;

  //Hour

  WeatherModel({
    this.cityName,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.localtime,
    this.centrigade,
    this.icon,
    this.cloud,
    this.faranheit,
    this.humidity,
    this.precipin,
    this.precipmm,
    this.tempc,
    this.pressuremb,
    this.pressurein,
    this.tempf,
    this.winddegree,
    this.windDirection,
    this.windkph,
    this.windmph,
    this.visionKM,
    this.visionMiles,
    this.isDay,
    this.forecastWeather,
    this.forecastDescription,
    this.forecastIcon,
    this.sunset,
    this.sunrise,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.moonIllumination,
    this.uv,
    this.totalPrecipMM,
    this.totalPrecipIN,
    this.maxWindMph,
    this.maxWindKph,
    this.maxtempC,
    this.avgVisM,
    this.avgHumidity,
    this.avgVisKM,
    this.avgTempC,
    this.avgTempF,
    this.maxTempF,
    this.minTempC,
    this.minTempF,
    this.description,
    this.hour,
  });

  WeatherModel.fromResponse(BaseClass base)
      : cityName = base.location.name,
        region = base.location.region,
        country = base.location.country,
        lat = base.location.lat,
        lon = base.location.lon,
        localtime = base.location.localtime,
        centrigade = base.current.centrigade,
        tempc = base.current.tempc,
        tempf = base.current.tempf,
        faranheit = base.current.faranheit,
        cloud = base.current.cloud,
        humidity = base.current.humidity,
        winddegree = base.current.winddegree,
        windDirection = base.current.windDirection,
        windkph = base.current.windkph,
        windmph = base.current.windmph,
        precipin = base.current.precipin,
        precipmm = base.current.precipmm,
        pressuremb = base.current.pressuremb,
        pressurein = base.current.precipin,
        visionKM = base.current.visionKM,
        visionMiles = base.current.visionM,
        isDay = base.current.isDay,
        description = base.current.condition.text,
        icon = base.current.condition.icon,
        forecastWeather = base.forecast.forecastWeather,
        maxtempC = base.forecast.forecastWeather[0].day.maxtempC,
        maxTempF = base.forecast.forecastWeather[0].day.maxtempF,
        minTempC = base.forecast.forecastWeather[0].day.mintempC,
        minTempF = base.forecast.forecastWeather[0].day.mintempF,
        avgTempC = base.forecast.forecastWeather[0].day.avgtempC,
        avgTempF = base.forecast.forecastWeather[0].day.avgtempF,
        maxWindMph = base.forecast.forecastWeather[0].day.maxWindMph,
        maxWindKph = base.forecast.forecastWeather[0].day.maxWindKph,
        totalPrecipIN = base.forecast.forecastWeather[0].day.totalPrecipIN,
        totalPrecipMM = base.forecast.forecastWeather[0].day.totalPrecipMM,
        avgVisKM = base.forecast.forecastWeather[0].day.avgVisKM,
        avgVisM = base.forecast.forecastWeather[0].day.avgVisM,
        avgHumidity = base.forecast.forecastWeather[0].day.avgHumidity,
        forecastDescription =
            base.forecast.forecastWeather[0].day.forecastCondition.text,
        forecastIcon =
            base.forecast.forecastWeather[0].day.forecastCondition.icon,
        uv = base.forecast.forecastWeather[0].day.uv,
        sunrise = base.forecast.forecastWeather[0].astro.sunrise,
        sunset = base.forecast.forecastWeather[0].astro.sunset,
        moonrise = base.forecast.forecastWeather[0].astro.moonrise,
        moonset = base.forecast.forecastWeather[0].astro.moonset,
        moonPhase = base.forecast.forecastWeather[0].astro.moonPhase,
        moonIllumination =
            base.forecast.forecastWeather[0].astro.moonIllumination,
        hour = base.forecast.forecastWeather[0].hour;
}
