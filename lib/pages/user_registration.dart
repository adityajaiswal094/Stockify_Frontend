// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:stockify/components/custom_button.dart';
import 'package:stockify/components/custom_textformfield.dart';
import 'package:stockify/utils/helper.dart';
import '../utils/constants.dart' as constants;
import 'package:dio/dio.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        const url = "${constants.baseUrl}/register";

        final body = {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
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

        Map<String, dynamic> responseBody = response.data;

        if (context.mounted) {
          if (response.statusCode == 201) {
            Navigator.of(context).pushReplacementNamed("/signin");
          } else {
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
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                        CustomTextFormField(
                          controller: firstNameController,
                          hintText: "Enter first name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            } else if (!RegExp(r'^[a-z A-Z]+$')
                                .hasMatch(value)) {
                              return "Invalid name";
                            }
                            return null;
                          },
                        ),

                        //
                        CustomTextFormField(
                          controller: lastNameController,
                          hintText: "Enter last name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            } else if (!RegExp(r'^[a-z A-Z]+$')
                                .hasMatch(value)) {
                              return "Invalid name";
                            }
                            return null;
                          },
                        ),

                        //
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "Enter email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            } else if (!RegExp(r'^[\w-\.]+@([\w]+\.)+[\w]{2,5}')
                                .hasMatch(value)) {
                              return "Invalid email";
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
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          hintText: "Re-enter password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            } else if (confirmPasswordController.text !=
                                passwordController.text) {
                              return "Passwords don't match";
                            }
                            return null;
                          },
                        ),

                        //
                        CustomButton(
                          buttonText: "Sign Up",
                          onPressed: signUp,
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
                            Text("Have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, "/signin"),
                              child: Text(
                                "Sign In",
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
