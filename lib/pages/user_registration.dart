import 'package:flutter/material.dart';
import 'package:stockify/components/custom_textformfield.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      controller: userNameController,
                      hintText: "Enter username",
                    ),

                    //
                    CustomTextFormField(
                      controller: firstNameController,
                      hintText: "Enter first name",
                    ),

                    //
                    CustomTextFormField(
                      controller: lastNameController,
                      hintText: "Enter last name",
                    ),

                    //
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "Enter email",
                      keyboardType: TextInputType.emailAddress,
                    ),

                    //
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "Enter password",
                      obscureText: true,
                    ),

                    //
                    CustomTextFormField(
                      controller: confirmPasswordController,
                      hintText: "Re-enter password",
                      obscureText: true,
                    ),

                    //
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
