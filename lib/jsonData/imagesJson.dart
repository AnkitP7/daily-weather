import 'package:json_annotation/json_annotation.dart';

part 'imagesJson.g.dart';

@JsonSerializable()
class BaseClass extends Object with _$BaseClassSerializerMixin {
  @JsonKey(name: 'totalHits')
  int totalHits;
  @JsonKey(name: "hits")
  List<Hits> imagesList;

  BaseClass({
    this.imagesList,
    this.totalHits,
  });

  factory BaseClass.fromJson(Map<String, dynamic> json) =>
      _$BaseClassFromJson(json);
}

@JsonSerializable()
class Hits extends Object with _$HitsSerializerMixin {
  @JsonKey(name: "largeImageURL")
  String largeImageURL;
  @JsonKey(name: "webformatURL")
  String webformatURL;
  String type;
  String user;

  Hits({
    this.largeImageURL,
    this.type,
    this.user,
    this.webformatURL,
  });

  factory Hits.fromJson(Map<String, dynamic> json) => _$HitsFromJson(json);
}
