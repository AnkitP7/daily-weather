import 'package:json_annotation/json_annotation.dart';

part 'json.g.dart';

@JsonSerializable()
class BaseClass extends Object with _$BaseClassSerializerMixin {
  @JsonKey(name: "location")
  final Location location;
  @JsonKey(name: "current")
  final Current current;
  @JsonKey(name: "forecast")
  final Forecast forecast;

  BaseClass({this.location, this.current, this.forecast});

  factory BaseClass.fromJson(Map<String, dynamic> json) =>
      _$BaseClassFromJson(json);
}

@JsonSerializable()
class Location extends Object with _$LocationSerializerMixin {
  final String name;
  final String region;
  final String country;
  final double lon;
  final double lat;
  @JsonKey(name: "tz_id")
  final String timezone;
  @JsonKey(name: "localtime")
  final String localtime;

  Location({
    this.country,
    this.lat,
    this.localtime,
    this.lon,
    this.name,
    this.region,
    this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@JsonSerializable()
class Current extends Object with _$CurrentSerializerMixin {
  @JsonKey(name: "wind_mph")
  final double windmph;
  @JsonKey(name: "wind_kph")
  final double windkph;
  @JsonKey(name: "wind_dir")
  final String windDirection;
  @JsonKey(name: "wind_degree")
  final int winddegree;
  final int cloud;
  @JsonKey(name: "pressure_mb")
  final double pressuremb;
  @JsonKey(name: "pressure_in")
  final double pressurein;
  @JsonKey(name: "precip_mm")
  final double precipmm;
  @JsonKey(name: "precip_in")
  final double precipin;
  final int humidity;
  @JsonKey(name: "feelslike_c")
  final double centrigade;
  @JsonKey(name: "feelslike_f")
  final double faranheit;
  @JsonKey(name: "temp_c")
  final double tempc;
  @JsonKey(name: "temp_f")
  final double tempf;
  @JsonKey(name: "vis_km")
  final double visionKM;
  @JsonKey(name: "vis_miles")
  final double visionM;
  @JsonKey(name: "is_day")
  final int isDay;
  final Condition condition;

  Current({
    this.centrigade,
    this.cloud,
    this.faranheit,
    this.humidity,
    this.pressuremb,
    this.tempc,
    this.precipmm,
    this.precipin,
    this.pressurein,
    this.tempf,
    this.winddegree,
    this.windkph,
    this.windmph,
    this.windDirection,
    this.condition,
    this.visionKM,
    this.visionM,
    this.isDay,
  });

  factory Current.fromJson(Map<String, dynamic> json) =>
      _$CurrentFromJson(json);
}

@JsonSerializable()
class Condition extends Object with _$ConditionSerializerMixin {
  final String text;
  final String icon;
  final int code;

  Condition({this.text, this.code, this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);
}

@JsonSerializable()
class Forecast extends Object with _$ForecastSerializerMixin {
  @JsonKey(name: "forecastday")
  final List<ForecastWeather> forecastWeather;

  Forecast({this.forecastWeather});

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      _$ForecastFromJson(json);
}

@JsonSerializable()
class ForecastWeather extends Object with _$ForecastWeatherSerializerMixin {
  @JsonKey(name: "date")
  final String date;

  final Day day;
  final Astro astro;
  final List<Hour> hour;

  ForecastWeather({this.date, this.astro, this.day, this.hour});

  factory ForecastWeather.fromJson(Map<String, dynamic> json) =>
      _$ForecastWeatherFromJson(json);
}

@JsonSerializable()
class Day extends Object with _$DaySerializerMixin {
  @JsonKey(name: "maxtemp_c")
  final double maxtempC;
  @JsonKey(name: "maxtemp_f")
  final double maxtempF;
  @JsonKey(name: "mintemp_c")
  final double mintempC;
  @JsonKey(name: "mintemp_f")
  final double mintempF;
  @JsonKey(name: "avgtemp_c")
  final double avgtempC;
  @JsonKey(name: "avgtemp_f")
  final double avgtempF;
  @JsonKey(name: "maxwind_kph")
  final double maxWindKph;
  @JsonKey(name: "maxwind_mph")
  final double maxWindMph;
  @JsonKey(name: "totalprecip_mm")
  final double totalPrecipMM;
  @JsonKey(name: "totalprecip_in")
  final double totalPrecipIN;
  @JsonKey(name: "avgvis_km")
  final double avgVisKM;
  @JsonKey(name: "avgvis_miles")
  final double avgVisM;
  @JsonKey(name: "avghumidity")
  final double avgHumidity;
  final double uv;
  @JsonKey(name: "condition")
  final ForecastCondition forecastCondition;

  Day({
    this.avgHumidity,
    this.avgtempC,
    this.avgtempF,
    this.avgVisKM,
    this.avgVisM,
    this.maxtempC,
    this.maxtempF,
    this.maxWindKph,
    this.maxWindMph,
    this.mintempC,
    this.mintempF,
    this.totalPrecipIN,
    this.totalPrecipMM,
    this.forecastCondition,
    this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
}

@JsonSerializable()
class ForecastCondition extends Object with _$ForecastConditionSerializerMixin {
  final String text;
  final String icon;
  final int code;

  ForecastCondition({
    this.code,
    this.icon,
    this.text,
  });

  factory ForecastCondition.fromJson(Map<String, dynamic> json) =>
      _$ForecastConditionFromJson(json);
}

@JsonSerializable()
class Astro extends Object with _$AstroSerializerMixin {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  @JsonKey(name: "moon_phase")
  final String moonPhase;
  @JsonKey(name: "moon_illumination")
  final String moonIllumination;

  Astro(
      {this.moonrise,
      this.moonset,
      this.sunrise,
      this.sunset,
      this.moonIllumination,
      this.moonPhase});

  factory Astro.fromJson(Map<String, dynamic> json) => _$AstroFromJson(json);
}

@JsonSerializable()
class Hour extends Object with _$HourSerializerMixin {
  final String time;
  @JsonKey(name: "temp_c")
  final double tempC;
  @JsonKey(name: "temp_f")
  final double tempF;
  @JsonKey(name: "is_day")
  final int isDay;
  @JsonKey(name: "condition")
  final HourCondition hourCondition;
  @JsonKey(name: "wind_mph")
  final double windMph;
  @JsonKey(name: "wind_kph")
  final double windKph;
  @JsonKey(name: "wind_degree")
  final int windDegree;
  @JsonKey(name: "wind_dir")
  final String windDirection;
  @JsonKey(name: "pressure_mb")
  final double pressureMB;
  @JsonKey(name: "pressure_in")
  final double pressureIN;
  @JsonKey(name: "precip_mm")
  final double precipMM;
  @JsonKey(name: "precip_in")
  final double precipIN;
  final int humidity;
  final int cloud;
  @JsonKey(name: "feelslike_c")
  final double feelsLikeC;
  @JsonKey(name: "feelslike_f")
  final double feelsLikeF;
  @JsonKey(name: "windchill_f")
  final double windChillF;
  @JsonKey(name: "windchill_c")
  final double windChillC;
  @JsonKey(name: "heatindex_c")
  final double heatIndexC;
  @JsonKey(name: "heatindex_f")
  final double heatIndexF;
  @JsonKey(name: "dewpoint_c")
  final double dewPointC;
  @JsonKey(name: "dewpoint_f")
  final double dewPointF;
  @JsonKey(name: "will_it_rain")
  final int willItRain;
  @JsonKey(name: "chance_of_rain")
  final String chanceOfRain;
  @JsonKey(name: "will_it_snow")
  final int willItSnow;
  @JsonKey(name: "chance_of_snow")
  final String chanceOfSnow;
  @JsonKey(name: "vis_km")
  final double visionKM;
  @JsonKey(name: "vis_miles")
  final double visionMiles;

  Hour(
      {this.time,
      this.cloud,
      this.chanceOfSnow,
      this.chanceOfRain,
      this.dewPointC,
      this.dewPointF,
      this.feelsLikeC,
      this.feelsLikeF,
      this.heatIndexC,
      this.heatIndexF,
      this.hourCondition,
      this.humidity,
      this.isDay,
      this.precipIN,
      this.precipMM,
      this.pressureIN,
      this.pressureMB,
      this.tempC,
      this.tempF,
      this.visionKM,
      this.visionMiles,
      this.willItRain,
      this.willItSnow,
      this.windChillC,
      this.windChillF,
      this.windDegree,
      this.windDirection,
      this.windKph,
      this.windMph});

  factory Hour.fromJson(Map<String, dynamic> json) => _$HourFromJson(json);
}

@JsonSerializable()
class HourCondition extends Object with _$HourConditionSerializerMixin {
  final String text;
  final String icon;
  final int code;

  HourCondition({
    this.code,
    this.text,
    this.icon,
  });

  factory HourCondition.fromJson(Map<String, dynamic> json) =>
      _$HourConditionFromJson(json);
}
