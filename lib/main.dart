import 'package:app_banners_asiste/presentation/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_banners_asiste/presentation/pages/inicio_page.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BannerProvider()),
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
      title: 'App Banner Asiste',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const InicioPage(),
      );
  }
}