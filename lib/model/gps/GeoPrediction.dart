class GeoPrediction {
  GeoPrediction({
    required this.type,
    required this.name,
    required this.crs,
    required this.features,
  });

  final String? type;
  final String? name;
  final Crs? crs;
  final List<Feature> features;

  factory GeoPrediction.fromJson(Map<String, dynamic> json) {
    return GeoPrediction(
      type: json["type"],
      name: json["name"],
      crs: json["crs"] == null ? null : Crs.fromJson(json["crs"]),
      features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$type, $name, $crs, $features, ";
  }
}

class Crs {
  Crs({
    required this.type,
    required this.properties,
  });

  final String? type;
  final CrsProperties? properties;

  factory Crs.fromJson(Map<String, dynamic> json) {
    return Crs(
      type: json["type"],
      properties: json["properties"] == null ? null : CrsProperties.fromJson(json["properties"]),
    );
  }

  @override
  String toString() {
    return "$type, $properties, ";
  }
}

class CrsProperties {
  CrsProperties({
    required this.name,
  });

  final String? name;

  factory CrsProperties.fromJson(Map<String, dynamic> json) {
    return CrsProperties(
      name: json["name"],
    );
  }

  @override
  String toString() {
    return "$name, ";
  }
}

class Feature {
  Feature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  final String? type;
  final FeatureProperties? properties;
  final Geometry? geometry;

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json["type"],
      properties: json["properties"] == null ? null : FeatureProperties.fromJson(json["properties"]),
      geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    );
  }

  @override
  String toString() {
    return "$type, $properties, $geometry, ";
  }
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  final String? type;
  final List<List<List<List<double>>>> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<List<List<List<double>>>>.from(json["coordinates"]!.map((x) => x == null
              ? []
              : List<List<List<double>>>.from(x!.map(
                  (x) => x == null ? [] : List<List<double>>.from(x!.map((x) => x == null ? [] : List<double>.from(x!.map((x) => x)))))))),
    );
  }

  @override
  String toString() {
    return "$type, $coordinates, ";
  }
}

class FeatureProperties {
  FeatureProperties({
    required this.id,
  });

  final int? id;

  factory FeatureProperties.fromJson(Map<String, dynamic> json) {
    return FeatureProperties(
      id: json["id"],
    );
  }

  @override
  String toString() {
    return "$id, ";
  }
}
