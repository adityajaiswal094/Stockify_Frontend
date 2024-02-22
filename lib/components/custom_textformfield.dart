import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          keyboardType: widget.keyboardType ?? TextInputType.name,
          obscureText: widget.obscureText ?? false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            hintText: widget.hintText,
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
