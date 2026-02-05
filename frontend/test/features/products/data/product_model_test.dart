import 'package:flutter_test/flutter_test.dart';
import 'package:product_app/features/products/data/product_model.dart';
import 'package:product_app/features/products/domain/product.dart';

void main() {
  group('ProductModel Tests', () {
    test('Debe convertir un JSON válido en una entidad Product', () {
      final Map<String, dynamic> json = {
        "id": 1,
        "sku": "HEAD-001",
        "name": "Auriculares",
        "price": 150.50,
        "currency": "BOB",
        "stock": 10,
      };

      final result = ProductModel.fromJson(json);

      expect(result, isA<Product>());
      expect(result.id, 1);
      expect(result.name, "Auriculares");
      expect(result.price, 150.50);
    });

    test('Debe manejar valores nulos asignando valores por defecto', () {
      final Map<String, dynamic> jsonConNulos = {"id": 2, "price": 0};

      final result = ProductModel.fromJson(jsonConNulos);

      expect(result.sku, '');
      expect(result.name, 'Sin Nombre');
      expect(result.stock, 0);
      expect(result.currency, 'BOB');
    });
  });
}
