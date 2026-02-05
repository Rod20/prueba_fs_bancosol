import 'package:go_router/go_router.dart';
import '../features/products/presentation/screens/product_list_screen.dart';

final productsRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProductListScreen()),
  ],
);
