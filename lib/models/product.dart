class Product {
  final int? id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  Product({this.id, required this.name, required this.price, required this.imageUrl, this.quantity = 0});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      quantity: map['quantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
} 