import 'package:daily_weather/jsonData/imagesJson.dart';

class ImageData {
  List<Hits> imagesList = new List();
  int totalHits;

  ImageData({
    this.totalHits,
  });

  ImageData.fromResponse(BaseClass baseClass)
      : imagesList = baseClass.imagesList;
}
