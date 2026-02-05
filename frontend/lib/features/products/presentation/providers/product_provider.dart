import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  ProductsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    try {
      _page = 1;
      _hasMore = true;
      _isLoadingMore = false;
      state = const AsyncValue.loading();

      final products = await _fetchProducts(page: 1);

      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasMore || !state.hasValue) return;

    _isLoadingMore = true;

    try {
      final currentList = state.value!;
      final newProducts = await _fetchProducts(page: _page + 1);

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _page++;
        state = AsyncValue.data([...currentList, ...newProducts]);
      }
    } catch (e) {
      print("Error cargando página $_page: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<List<Product>> _fetchProducts({required int page}) {
    final repository = ref.read(productRepositoryProvider);
    final filters = ref.read(productFilterProvider);

    return repository.getProducts(
      search: filters.search,
      sort: filters.sort,
      onlyAvailable: filters.onlyAvailable,
      page: page,
    );
  }
}

final productsListProvider =
    StateNotifierProvider.autoDispose<
      ProductsNotifier,
      AsyncValue<List<Product>>
    >((ref) {
      ref.watch(productFilterProvider);
      return ProductsNotifier(ref);
    });
