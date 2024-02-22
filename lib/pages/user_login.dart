import 'package:flutter/material.dart';
import 'package:stockify/components/custom_button.dart';
import 'package:stockify/components/custom_textformfield.dart';
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

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      // show proper error message in dialog box for password not matching
      // the error message which will be returned by api response
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

        Map<String, dynamic> responseBody = response.data;

        if (context.mounted) {
          if (response.statusCode == 200) {
            Navigator.popAndPushNamed(context, "/homepage");
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
                        const SizedBox(
                          height: 25.0,
                        ),

                        //
                        CustomButton(
                          buttonText: "Sign In",
                          onPressed: signIn,
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
                              onTap: () => Navigator.popAndPushNamed(
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
