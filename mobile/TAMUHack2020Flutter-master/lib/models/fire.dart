class Fire {
  String confidence;
  double lat;
  double lon;
  double distance;
  int direction;

  Fire(this.confidence, this.lat, this.lon, this.distance, this.direction);

  factory Fire.fromJson(Map<String, dynamic> json) {
    return new Fire(
        json["confidence"],
        json["position"]["lat"],
        json["position"]["lon"],
        json["position"]["distance"]["value"],
        json["position"]["direction"]);
  }
}

class FireList {
  List<Fire> fires;

  FireList(this.fires);

  factory FireList.fromJson(Map<String, dynamic> json) {
    List<Fire> fires = new List<Fire>.from(json["data"]["fires"].map((i) => Fire.fromJson(i)));

    return new FireList(fires);
  }
}
