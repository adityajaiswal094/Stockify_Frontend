// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockify/pages/home_page.dart';
import 'package:stockify/pages/search_page.dart';
import 'package:stockify/pages/stock_page.dart';
import 'package:stockify/pages/user_login.dart';
import 'package:stockify/pages/user_registration.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 1, 0, 20),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Colors.white, fontSize: 24),
          titleMedium: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(
              color: Color.fromARGB(255, 0, 126, 253),
              fontSize: 18,
              fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
          bodySmall: TextStyle(color: Colors.white, fontSize: 14),
          labelSmall: TextStyle(color: Colors.white, fontSize: 10),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: const Color.fromARGB(255, 1, 0, 20),
          onPrimary: const Color.fromARGB(255, 0, 126, 253),
          secondary: const Color.fromARGB(255, 50, 53, 74),
          onSecondary: const Color.fromARGB(255, 92, 98, 138),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        "/homepage": (context) => const HomePage(),
        "/stockpage": (context) => const StockPage(),
        "/searchpage": (context) => const SearchPage(),
        "/register": (context) => const UserRegistration(),
        "/signin": (context) => const UserLogin(),
      },
    );
  }
}
