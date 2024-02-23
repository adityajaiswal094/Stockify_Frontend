import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          keyboardType: keyboardType ?? TextInputType.name,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodySmall,
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
          ),
          style: Theme.of(context).textTheme.bodyMedium,
          validator: validator,
        ),

        //
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
