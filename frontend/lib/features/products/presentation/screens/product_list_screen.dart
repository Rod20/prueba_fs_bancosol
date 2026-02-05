import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:product_app/features/products/presentation/widgets/upgrade_price_modal.dart';
import '../../../../config/app_colors.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(productFilterProvider.notifier).setSearch(query);
    });
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FilterModalContent(),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productsListProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsListProvider);
    final filters = ref.watch(productFilterProvider);
    final bool hasActiveFilters = filters.onlyAvailable || filters.sort != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo BancoSol')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o SKU...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: hasActiveFilters ? AppColors.secondary : Colors.grey,
                  ),
                  tooltip: 'Filtrar y Ordenar',
                  onPressed: () => _showFilterModal(context),
                ),
              ),
            ),
          ),

          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              ),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No se encontraron productos'),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(productsListProvider),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length + 1,
                    itemBuilder: (context, index) {
                      if (index == products.length) {
                        if (products.length < 15) {
                          return const SizedBox.shrink();
                        }
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }
                      final product = products[index];

                      final formatCurrency = NumberFormat.currency(
                        symbol: 'Bs. ',
                        decimalDigits: 2,
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (ctx) =>
                                  UpdatePriceModal(product: product),
                            );
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.inventory_2,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(product.sku),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatCurrency.format(product.price),
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                product.stock > 0
                                    ? '${product.stock} disp.'
                                    : 'Agotado',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: product.stock > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterModalContent extends ConsumerWidget {
  const _FilterModalContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(productFilterProvider);
    final notifier = ref.read(productFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtrar Productos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  notifier.setSort(null);
                  if (filters.onlyAvailable) notifier.toggleAvailable();
                  Navigator.pop(context);
                },
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          const Text(
            'Disponibilidad',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mostrar solo disponibles'),
            subtitle: const Text('Ocultar productos sin stock'),
            activeColor: AppColors.secondary,
            value: filters.onlyAvailable,
            onChanged: (bool val) {
              notifier.toggleAvailable();
            },
          ),
          const SizedBox(height: 10),

          const Text(
            'Ordenar por Precio',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          RadioGroup<String?>(
            groupValue: filters.sort,
            onChanged: (val) => notifier.setSort(val),
            child: Column(
              children: [
                RadioListTile<String?>(
                  title: const Text('Por defecto'),
                  value: null,
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String?>(
                  title: const Text('Menor precio primero'),
                  value: 'price_asc',
                  activeColor: AppColors.secondary,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String?>(
                  title: const Text('Mayor precio primero'),
                  value: 'price_desc',
                  activeColor: AppColors.secondary,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('LISTO'),
            ),
          ),
        ],
      ),
    );
  }
}
