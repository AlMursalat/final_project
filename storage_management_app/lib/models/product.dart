import 'category.dart';

class Product {
  final int id;
  final String name;
  final int quantity;
  final String imageUrl;
  final Category category;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] ?? 0, // Menggunakan nilai default jika null
    name: json['name'] ?? '',
    quantity: json['quantity'] ?? 0,
    imageUrl: json['imageUrl'] ?? '',
    category: json['category'] != null ? Category.fromJson(json['category']) : Category(id: 0, name: ''), // Contoh nilai default untuk Category
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'category': category.toJson(),
    };
  }

  // Tambahkan metode copyWith untuk menghasilkan objek baru dengan perubahan tertentu
  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    String? imageUrl,
    Category? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
}
