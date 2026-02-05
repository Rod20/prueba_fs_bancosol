import '../../../../core/api_client.dart';
import '../domain/product.dart';
import 'product_model.dart';

class ProductRepository {
  Future<List<Product>> getProducts({String? search}) async {
    try {
      final response = await dioClient.get(
        '/products',
        queryParameters: search != null && search.isNotEmpty
            ? {'search': search}
            : null,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar productos: $e');
    }
  }

  Future<void> updatePrice(int id, double newPrice) async {
    try {
      await dioClient.patch('/products/$id', data: {'price': newPrice});
    } catch (e) {
      throw Exception('Error al actualizar precio: $e');
    }
  }
}
