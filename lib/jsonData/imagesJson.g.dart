// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagesJson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseClass _$BaseClassFromJson(Map<String, dynamic> json) {
  return new BaseClass(
      imagesList: (json['hits'] as List)
          ?.map((e) =>
              e == null ? null : new Hits.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      totalHits: json['totalHits'] as int);
}

abstract class _$BaseClassSerializerMixin {
  int get totalHits;
  List<Hits> get imagesList;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'totalHits': totalHits, 'hits': imagesList};
}

Hits _$HitsFromJson(Map<String, dynamic> json) {
  return new Hits(
      largeImageURL: json['largeImageURL'] as String,
      type: json['type'] as String,
      user: json['user'] as String,
      webformatURL: json['webformatURL'] as String);
}

abstract class _$HitsSerializerMixin {
  String get largeImageURL;
  String get webformatURL;
  String get type;
  String get user;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'largeImageURL': largeImageURL,
        'webformatURL': webformatURL,
        'type': type,
        'user': user
      };
}
