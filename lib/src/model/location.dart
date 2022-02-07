class Location {
  String name;
  String formattedAddress;
  double lat;
  double lng;

  Location({this.name, this.formattedAddress, this.lat, this.lng});

  @override
  String toString() {
    return 'Location{name: $name, formattedAddress: $formattedAddress, lat: $lat, lng: $lng}';
  }

/*factory Location.fromJson(Map<String, dynamic> map) {
    return Location(
      name: map['name'],
      formattedAddress: map['formatted_address'],
      lat: map['geometry']['location']['lat'],
      lng: map['geometry']['location']['lng'],
    );
  }

  static List<Location> parseLocationList(map) {
    var list = map['results'] as List;
    return list.map((movie) => Location.fromJson(movie)).toList();
  }*/


}
