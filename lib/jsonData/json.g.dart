// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseClass _$BaseClassFromJson(Map<String, dynamic> json) {
  return new BaseClass(
      location: json['location'] == null
          ? null
          : new Location.fromJson(json['location'] as Map<String, dynamic>),
      current: json['current'] == null
          ? null
          : new Current.fromJson(json['current'] as Map<String, dynamic>),
      forecast: json['forecast'] == null
          ? null
          : new Forecast.fromJson(json['forecast'] as Map<String, dynamic>));
}

abstract class _$BaseClassSerializerMixin {
  Location get location;
  Current get current;
  Forecast get forecast;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'location': location,
        'current': current,
        'forecast': forecast
      };
}

Location _$LocationFromJson(Map<String, dynamic> json) {
  return new Location(
      country: json['country'] as String,
      lat: (json['lat'] as num)?.toDouble(),
      localtime: json['localtime'] as String,
      lon: (json['lon'] as num)?.toDouble(),
      name: json['name'] as String,
      region: json['region'] as String,
      timezone: json['tz_id'] as String);
}

abstract class _$LocationSerializerMixin {
  String get name;
  String get region;
  String get country;
  double get lon;
  double get lat;
  String get timezone;
  String get localtime;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'region': region,
        'country': country,
        'lon': lon,
        'lat': lat,
        'tz_id': timezone,
        'localtime': localtime
      };
}

Current _$CurrentFromJson(Map<String, dynamic> json) {
  return new Current(
      centrigade: (json['feelslike_c'] as num)?.toDouble(),
      cloud: json['cloud'] as int,
      faranheit: (json['feelslike_f'] as num)?.toDouble(),
      humidity: json['humidity'] as int,
      pressuremb: (json['pressure_mb'] as num)?.toDouble(),
      tempc: (json['temp_c'] as num)?.toDouble(),
      precipmm: (json['precip_mm'] as num)?.toDouble(),
      precipin: (json['precip_in'] as num)?.toDouble(),
      pressurein: (json['pressure_in'] as num)?.toDouble(),
      tempf: (json['temp_f'] as num)?.toDouble(),
      winddegree: json['wind_degree'] as int,
      windkph: (json['wind_kph'] as num)?.toDouble(),
      windmph: (json['wind_mph'] as num)?.toDouble(),
      windDirection: json['wind_dir'] as String,
      condition: json['condition'] == null
          ? null
          : new Condition.fromJson(json['condition'] as Map<String, dynamic>),
      visionKM: (json['vis_km'] as num)?.toDouble(),
      visionM: (json['vis_miles'] as num)?.toDouble(),
      isDay: json['is_day'] as int);
}

abstract class _$CurrentSerializerMixin {
  double get windmph;
  double get windkph;
  String get windDirection;
  int get winddegree;
  int get cloud;
  double get pressuremb;
  double get pressurein;
  double get precipmm;
  double get precipin;
  int get humidity;
  double get centrigade;
  double get faranheit;
  double get tempc;
  double get tempf;
  double get visionKM;
  double get visionM;
  int get isDay;
  Condition get condition;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'wind_mph': windmph,
        'wind_kph': windkph,
        'wind_dir': windDirection,
        'wind_degree': winddegree,
        'cloud': cloud,
        'pressure_mb': pressuremb,
        'pressure_in': pressurein,
        'precip_mm': precipmm,
        'precip_in': precipin,
        'humidity': humidity,
        'feelslike_c': centrigade,
        'feelslike_f': faranheit,
        'temp_c': tempc,
        'temp_f': tempf,
        'vis_km': visionKM,
        'vis_miles': visionM,
        'is_day': isDay,
        'condition': condition
      };
}

Condition _$ConditionFromJson(Map<String, dynamic> json) {
  return new Condition(
      text: json['text'] as String,
      code: json['code'] as int,
      icon: json['icon'] as String);
}

abstract class _$ConditionSerializerMixin {
  String get text;
  String get icon;
  int get code;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'text': text, 'icon': icon, 'code': code};
}

Forecast _$ForecastFromJson(Map<String, dynamic> json) {
  return new Forecast(
      forecastWeather: (json['forecastday'] as List)
          ?.map((e) => e == null
              ? null
              : new ForecastWeather.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$ForecastSerializerMixin {
  List<ForecastWeather> get forecastWeather;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'forecastday': forecastWeather};
}

ForecastWeather _$ForecastWeatherFromJson(Map<String, dynamic> json) {
  return new ForecastWeather(
      date: json['date'] as String,
      astro: json['astro'] == null
          ? null
          : new Astro.fromJson(json['astro'] as Map<String, dynamic>),
      day: json['day'] == null
          ? null
          : new Day.fromJson(json['day'] as Map<String, dynamic>),
      hour: (json['hour'] as List)
          ?.map((e) =>
              e == null ? null : new Hour.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

abstract class _$ForecastWeatherSerializerMixin {
  String get date;
  Day get day;
  Astro get astro;
  List<Hour> get hour;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'date': date, 'day': day, 'astro': astro, 'hour': hour};
}

Day _$DayFromJson(Map<String, dynamic> json) {
  return new Day(
      avgHumidity: (json['avghumidity'] as num)?.toDouble(),
      avgtempC: (json['avgtemp_c'] as num)?.toDouble(),
      avgtempF: (json['avgtemp_f'] as num)?.toDouble(),
      avgVisKM: (json['avgvis_km'] as num)?.toDouble(),
      avgVisM: (json['avgvis_miles'] as num)?.toDouble(),
      maxtempC: (json['maxtemp_c'] as num)?.toDouble(),
      maxtempF: (json['maxtemp_f'] as num)?.toDouble(),
      maxWindKph: (json['maxwind_kph'] as num)?.toDouble(),
      maxWindMph: (json['maxwind_mph'] as num)?.toDouble(),
      mintempC: (json['mintemp_c'] as num)?.toDouble(),
      mintempF: (json['mintemp_f'] as num)?.toDouble(),
      totalPrecipIN: (json['totalprecip_in'] as num)?.toDouble(),
      totalPrecipMM: (json['totalprecip_mm'] as num)?.toDouble(),
      forecastCondition: json['condition'] == null
          ? null
          : new ForecastCondition.fromJson(
              json['condition'] as Map<String, dynamic>),
      uv: (json['uv'] as num)?.toDouble());
}

abstract class _$DaySerializerMixin {
  double get maxtempC;
  double get maxtempF;
  double get mintempC;
  double get mintempF;
  double get avgtempC;
  double get avgtempF;
  double get maxWindKph;
  double get maxWindMph;
  double get totalPrecipMM;
  double get totalPrecipIN;
  double get avgVisKM;
  double get avgVisM;
  double get avgHumidity;
  double get uv;
  ForecastCondition get forecastCondition;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'maxtemp_c': maxtempC,
        'maxtemp_f': maxtempF,
        'mintemp_c': mintempC,
        'mintemp_f': mintempF,
        'avgtemp_c': avgtempC,
        'avgtemp_f': avgtempF,
        'maxwind_kph': maxWindKph,
        'maxwind_mph': maxWindMph,
        'totalprecip_mm': totalPrecipMM,
        'totalprecip_in': totalPrecipIN,
        'avgvis_km': avgVisKM,
        'avgvis_miles': avgVisM,
        'avghumidity': avgHumidity,
        'uv': uv,
        'condition': forecastCondition
      };
}

ForecastCondition _$ForecastConditionFromJson(Map<String, dynamic> json) {
  return new ForecastCondition(
      code: json['code'] as int,
      icon: json['icon'] as String,
      text: json['text'] as String);
}

abstract class _$ForecastConditionSerializerMixin {
  String get text;
  String get icon;
  int get code;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'text': text, 'icon': icon, 'code': code};
}

Astro _$AstroFromJson(Map<String, dynamic> json) {
  return new Astro(
      moonrise: json['moonrise'] as String,
      moonset: json['moonset'] as String,
      sunrise: json['sunrise'] as String,
      sunset: json['sunset'] as String,
      moonIllumination: json['moon_illumination'] as String,
      moonPhase: json['moon_phase'] as String);
}

abstract class _$AstroSerializerMixin {
  String get sunrise;
  String get sunset;
  String get moonrise;
  String get moonset;
  String get moonPhase;
  String get moonIllumination;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'sunrise': sunrise,
        'sunset': sunset,
        'moonrise': moonrise,
        'moonset': moonset,
        'moon_phase': moonPhase,
        'moon_illumination': moonIllumination
      };
}

Hour _$HourFromJson(Map<String, dynamic> json) {
  return new Hour(
      time: json['time'] as String,
      cloud: json['cloud'] as int,
      chanceOfSnow: json['chance_of_snow'] as String,
      chanceOfRain: json['chance_of_rain'] as String,
      dewPointC: (json['dewpoint_c'] as num)?.toDouble(),
      dewPointF: (json['dewpoint_f'] as num)?.toDouble(),
      feelsLikeC: (json['feelslike_c'] as num)?.toDouble(),
      feelsLikeF: (json['feelslike_f'] as num)?.toDouble(),
      heatIndexC: (json['heatindex_c'] as num)?.toDouble(),
      heatIndexF: (json['heatindex_f'] as num)?.toDouble(),
      hourCondition: json['condition'] == null
          ? null
          : new HourCondition.fromJson(
              json['condition'] as Map<String, dynamic>),
      humidity: json['humidity'] as int,
      isDay: json['is_day'] as int,
      precipIN: (json['precip_in'] as num)?.toDouble(),
      precipMM: (json['precip_mm'] as num)?.toDouble(),
      pressureIN: (json['pressure_in'] as num)?.toDouble(),
      pressureMB: (json['pressure_mb'] as num)?.toDouble(),
      tempC: (json['temp_c'] as num)?.toDouble(),
      tempF: (json['temp_f'] as num)?.toDouble(),
      visionKM: (json['vis_km'] as num)?.toDouble(),
      visionMiles: (json['vis_miles'] as num)?.toDouble(),
      willItRain: json['will_it_rain'] as int,
      willItSnow: json['will_it_snow'] as int,
      windChillC: (json['windchill_c'] as num)?.toDouble(),
      windChillF: (json['windchill_f'] as num)?.toDouble(),
      windDegree: json['wind_degree'] as int,
      windDirection: json['wind_dir'] as String,
      windKph: (json['wind_kph'] as num)?.toDouble(),
      windMph: (json['wind_mph'] as num)?.toDouble());
}

abstract class _$HourSerializerMixin {
  String get time;
  double get tempC;
  double get tempF;
  int get isDay;
  HourCondition get hourCondition;
  double get windMph;
  double get windKph;
  int get windDegree;
  String get windDirection;
  double get pressureMB;
  double get pressureIN;
  double get precipMM;
  double get precipIN;
  int get humidity;
  int get cloud;
  double get feelsLikeC;
  double get feelsLikeF;
  double get windChillF;
  double get windChillC;
  double get heatIndexC;
  double get heatIndexF;
  double get dewPointC;
  double get dewPointF;
  int get willItRain;
  String get chanceOfRain;
  int get willItSnow;
  String get chanceOfSnow;
  double get visionKM;
  double get visionMiles;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'time': time,
        'temp_c': tempC,
        'temp_f': tempF,
        'is_day': isDay,
        'condition': hourCondition,
        'wind_mph': windMph,
        'wind_kph': windKph,
        'wind_degree': windDegree,
        'wind_dir': windDirection,
        'pressure_mb': pressureMB,
        'pressure_in': pressureIN,
        'precip_mm': precipMM,
        'precip_in': precipIN,
        'humidity': humidity,
        'cloud': cloud,
        'feelslike_c': feelsLikeC,
        'feelslike_f': feelsLikeF,
        'windchill_f': windChillF,
        'windchill_c': windChillC,
        'heatindex_c': heatIndexC,
        'heatindex_f': heatIndexF,
        'dewpoint_c': dewPointC,
        'dewpoint_f': dewPointF,
        'will_it_rain': willItRain,
        'chance_of_rain': chanceOfRain,
        'will_it_snow': willItSnow,
        'chance_of_snow': chanceOfSnow,
        'vis_km': visionKM,
        'vis_miles': visionMiles
      };
}

HourCondition _$HourConditionFromJson(Map<String, dynamic> json) {
  return new HourCondition(
      code: json['code'] as int,
      text: json['text'] as String,
      icon: json['icon'] as String);
}

abstract class _$HourConditionSerializerMixin {
  String get text;
  String get icon;
  int get code;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'text': text, 'icon': icon, 'code': code};
}
