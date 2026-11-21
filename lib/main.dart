import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Halaman praktikum pertemuan sebelumnya dapat dibuka dengan mengganti 'home':
// import 'column_widget.dart';
// import 'row_widget.dart';
// import 'first_widget.dart';
// import 'form_widget.dart';
// import 'app_theme.dart';
// import 'responsive_profile.dart';
// import 'assets_media.dart';
// import 'home_page.dart';
// import 'api_page.dart';

import 'providers/product_provider.dart';
import 'views/product_list_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Mobile Lanjut',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductListView(),
    );
  }
}
