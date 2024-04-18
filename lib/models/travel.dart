class Travel {
  int? id;
  final String name;
  final String city;
  final int numberOfPersons;
  final DateTime travelDate;
  final String image;
  final double cost;

  Travel({
    this.id,
    required this.name,
    required this.city,
    required this.numberOfPersons,
    required this.travelDate,
    required this.image,
    required this.cost,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'numberOfPersons': numberOfPersons,
      'travelDate': travelDate.toIso8601String(),
      'image': image,
      'cost': cost,
    };
  }

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      numberOfPersons: json['numberOfPersons'],
      travelDate: DateTime.parse(json['travelDate']),
      image: json['image'],
      cost: json['cost'],
    );
  }

  Travel copy({
    int? id,
    String? name,
    String? city,
    int? numberOfPersons,
    DateTime? travelDate,
    String? image,
    double? cost,
  }) {
    return Travel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
      travelDate: travelDate ?? this.travelDate,
      image: image ?? this.image,
      cost: cost ?? this.cost,
    );
  }
}
