import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/product.dart';
import '../../data/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

class ProductFilterState {
  final String search;
  final String? sort;
  final bool onlyAvailable;

  ProductFilterState({this.search = '', this.sort, this.onlyAvailable = false});

  ProductFilterState copyWith({
    String? search,
    String? sort,
    bool? onlyAvailable,
  }) {
    return ProductFilterState(
      search: search ?? this.search,
      sort: sort ?? this.sort,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
    );
  }
}

class FilterNotifier extends Notifier<ProductFilterState> {
  @override
  ProductFilterState build() => ProductFilterState();

  void setSearch(String query) => state = state.copyWith(search: query);
  void setSort(String? sortType) => state = state.copyWith(sort: sortType);
  void toggleAvailable() =>
      state = state.copyWith(onlyAvailable: !state.onlyAvailable);
}

final productFilterProvider =
    NotifierProvider<FilterNotifier, ProductFilterState>(() {
      return FilterNotifier();
    });

final productsListProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final repository = ref.watch(productRepositoryProvider);
  final filterState = ref.watch(productFilterProvider);
  return repository.getProducts(
    search: filterState.search,
    sort: filterState.sort,
    onlyAvailable: filterState.onlyAvailable,
  );
});
