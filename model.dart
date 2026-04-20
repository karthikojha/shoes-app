class ProductModel {
  int? id;
  String name;
  String price;
  String image;

  /// Constructor
  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  /// Convert object → Map (for database)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'image': image};
  }

  /// Convert Map → Object (from database)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
    );
  }
}
