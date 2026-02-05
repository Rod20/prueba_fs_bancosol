import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/features/products/presentation/screens/product_list_screen.dart';
import 'config/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BancoSol App',
      theme: AppTheme.getTheme(),
      themeMode: ThemeMode.light,
      home: const ProductListScreen(),
    );
  }
}
