class Vehicle {
  final int id;
  final String make;
  final String model;
  final int price;
  final String image;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.price,
    required this.image,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      price: json['price'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'price': price,
      'image': image,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      make: map['make'],
      model: map['model'],
      price: map['price'],
      image: map['image'],
    );
  }
}
