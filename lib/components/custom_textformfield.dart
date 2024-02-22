import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Function validationFunc;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText,
    required this.validationFunc,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required Field!";
            }
            return null;
          },
        ),

        //
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
