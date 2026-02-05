import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/config/products_router.dart';
import 'config/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BancoSol App',
      theme: AppTheme.getLight(),
      darkTheme: AppTheme.getDark(),
      themeMode: ThemeMode.system,
      routerConfig: productsRouter,
    );
  }
}
