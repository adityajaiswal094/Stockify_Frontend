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

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      // check if passwords match
      if (passwordController.text == confirmPasswordController.text) {
        // if passwords match then make api call
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
              Navigator.popAndPushNamed(context, "/signin");
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(responseBody['title']),
              //   ),
              // );
            } else {
              showDialogMessage(
                  context, responseBody['title'], responseBody['message']);
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        showDialogMessage(context, "Error", "Passwords Don't Match");
      }
    }
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
                          validationFunc: () {},
                        ),

                        //
                        CustomTextFormField(
                          controller: lastNameController,
                          hintText: "Enter last name",
                          validationFunc: () {},
                        ),

                        //
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "Enter email",
                          keyboardType: TextInputType.emailAddress,
                          validationFunc: () {},
                        ),

                        //
                        CustomTextFormField(
                          controller: passwordController,
                          hintText: "Enter password",
                          obscureText: true,
                          validationFunc: () {},
                        ),

                        //
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          hintText: "Re-enter password",
                          obscureText: true,
                          validationFunc: () {},
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
                              onTap: () =>
                                  Navigator.popAndPushNamed(context, "/signin"),
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
