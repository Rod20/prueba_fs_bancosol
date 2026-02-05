import '../domain/product.dart';

class ProductModel {
  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? 'Sin Nombre',
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'BOB',
      stock: json['stock'] as int? ?? 0,
    );
  }
}
