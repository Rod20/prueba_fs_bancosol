import '../../../../core/api_client.dart';
import '../domain/product.dart';
import 'product_model.dart';

class ProductRepository {
  Future<List<Product>> getProducts({
    String? search,
    String? sort,
    bool? onlyAvailable,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (sort != null) queryParams['sort'] = sort;
      if (onlyAvailable == true) queryParams['onlyAvailable'] = true;

      final response = await dioClient.get(
        '/products',
        queryParameters: queryParams,
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
