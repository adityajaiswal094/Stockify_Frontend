// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify/components/custom_button.dart';
import 'package:stockify/components/custom_textformfield.dart';
import 'package:stockify/store/store.dart';
import 'package:stockify/store/user_reducer.dart';
import 'package:stockify/utils/helper.dart';
import '../utils/constants.dart' as constants;
import 'package:dio/dio.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // List<dynamic> favouriteStocks = [];

  Future<void> keepLoggedIn(String userData) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userData', userData);
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      // store.dispatch(
      //     const LoadingAction(payload: {"isError": false, "isLoading": true}));
      try {
        const url = "${constants.baseUrl}/login";

        final body = {
          "email_id": emailController.text,
          "password": passwordController.text
        };

        final dio = Dio();

        final response = await dio.post(url,
            data: body,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              },
            ));

        var responseBody = response.data;

        if (context.mounted) {
          if (response.statusCode == 200) {
            Navigator.of(context).pushReplacementNamed("/homepage");

            store.dispatch(
              UserLoggedInAction(payload: responseBody['details']),
            );

            //
            keepLoggedIn(jsonEncode(responseBody['details']));
          } else {
            // store.dispatch(const ErrorAction(
            //     payload: {"isError": true, "isLoading": false}));
            showDialogMessage(
                context, responseBody['title'], responseBody['message']);
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "Enter email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            } else if (!RegExp(r'^[\w-\.]+@([\w]+\.)+[\w]{2,4}')
                                .hasMatch(value)) {
                              return "Enter correct email";
                            }
                            return null;
                          },
                        ),

                        //
                        CustomTextFormField(
                          controller: passwordController,
                          hintText: "Enter password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                        ),

                        //
                        const SizedBox(
                          height: 25.0,
                        ),

                        //
                        CustomButton(
                          buttonText: "Sign In",
                          onPressed: () {
                            signIn();
                          },
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width,
                        ),

                        //
                        const SizedBox(
                          height: 25,
                        ),

                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium),

                            //
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, "/register"),
                              child: Text(
                                "Sign Up",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
