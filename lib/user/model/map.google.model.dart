class AdrresGoogle {
  String status;
  List<Results> googlemap;

  AdrresGoogle({this.status, this.googlemap});

  factory AdrresGoogle.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<Results> mapList = list.map((i) => Results.fromJson(i)).toList();
    return AdrresGoogle(status: parsedJson['status'], googlemap: mapList);
  }
}

class Results {
  String placeId;
  String direccionformateada;
  List<AddressCoponents> addressComponets;
  Geometry geometry;
  Results(
      {this.placeId,
      this.direccionformateada,
      this.addressComponets,
      this.geometry});
  factory Results.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['address_components'] as List;
    var geometryf = parsedJson['geometry'] as Map<String, dynamic>;
    Geometry data = Geometry.fromJson(geometryf);
    List<AddressCoponents> componentsList =
        list.map((i) => AddressCoponents.fromJson(i)).toList();
    return Results(
        placeId: parsedJson['place_id'],
        direccionformateada: parsedJson['formatted_address'],
        addressComponets: componentsList,
        geometry: data);
  }
}

class AddressCoponents {
  String longName;
  String shortName;
  List<String> types;

  AddressCoponents({this.longName, this.shortName, this.types});

  factory AddressCoponents.fromJson(Map<String, dynamic> parsedJson) {
    var streetsFromJson = parsedJson['types'];
    List<String> streetsList = streetsFromJson.cast<String>();
    return AddressCoponents(
        longName: parsedJson['long_name'],
        shortName: parsedJson['short_name'],
        types: streetsList);
  }
}

/*class Types {
  List<String> types;
  Types({this.types});
  factory Types.fromJson(Map<String, dynamic> parsedJson) {
    var streetsFromJson = parsedJson['types'];
    List<String> streetsList = streetsFromJson.cast<String>();

    return new Types(
      types: streetsList,
    );
  }
}*/

class Geometry {
  Location location;
  String locationtype;
  Viewport viewport;
  Geometry({this.location, this.locationtype, this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> parsedJson) {
    var location = parsedJson['location'] as Map<String, dynamic>;
    var viewport = parsedJson['viewport'] as Map<String, dynamic>;

    Location data = Location.fromJson(location);
    Viewport viewdata = Viewport.fromJson(viewport);
    return Geometry(
        location: data,
        locationtype: parsedJson['location_type'],
        viewport: viewdata);
  }
}

class Location {
  double latY;
  double longX;

  Location({this.latY, this.longX});

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(latY: parsedJson['lat'], longX: parsedJson['lng']);
  }
}

class Viewport {
  Northeast northeast;
  Southwest southwest;
  Viewport({this.northeast, this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> parsedJson) {
    var nort = parsedJson['northeast'] as Map<String, dynamic>;
    var sout = parsedJson['southwest'] as Map<String, dynamic>;
    Northeast nordata = Northeast.fromJson(nort);
    Southwest surdata = Southwest.fromJson(sout);
    return Viewport(northeast: nordata, southwest: surdata);
  }
}

class Northeast {
  double latY;
  double longX;

  Northeast({this.latY, this.longX});

  factory Northeast.fromJson(Map<String, dynamic> parsedJson) {
    return Northeast(latY: parsedJson['lat'], longX: parsedJson['lng']);
  }
}

class Southwest {
  double latY;
  double longX;

  Southwest({this.latY, this.longX});

  factory Southwest.fromJson(Map<String, dynamic> parsedJson) {
    return Southwest(latY: parsedJson['lat'], longX: parsedJson['lng']);
  }
}
