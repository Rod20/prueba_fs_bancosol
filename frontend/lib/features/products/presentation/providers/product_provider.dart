import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/product.dart';
import '../../data/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

class SearchNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void update(String query) {
    state = query;
  }
}

final productSearchProvider = NotifierProvider<SearchNotifier, String>(() {
  return SearchNotifier();
});

final productsListProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final repository = ref.watch(productRepositoryProvider);

  final search = ref.watch(productSearchProvider);

  return repository.getProducts(search: search);
});
