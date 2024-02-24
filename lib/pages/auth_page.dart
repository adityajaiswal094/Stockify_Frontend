import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify/pages/home_page.dart';
import 'package:stockify/pages/user_login.dart';
import 'package:stockify/store/store.dart';
import 'package:stockify/store/user_reducer.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? user;

// check for loggedIn
  Future<void> checkUserLoggedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = sharedPreferences.getString('userData');
    setState(() {
      user = userData;
    });
    store.dispatch(
      UserLoggedInAction(
        payload: jsonDecode(userData ?? "{}") as Map<String, dynamic>,
      ),
    );
  }

  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null ? const HomePage() : const UserLogin();
  }
}
