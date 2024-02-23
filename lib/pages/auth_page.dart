import 'package:flutter/material.dart';
import 'package:stockify/pages/home_page.dart';
import 'package:stockify/pages/user_login.dart';
import 'package:stockify/store/store.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final isLoggedIn = store.state.isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return isLoggedIn == true ? const HomePage() : const UserLogin();
  }
}
