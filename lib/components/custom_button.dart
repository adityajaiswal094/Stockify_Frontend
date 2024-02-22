import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.height,
    required this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.onSecondary,
          foregroundColor: Colors.white,
          textStyle: Theme.of(context).textTheme.titleSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          buttonText,
        ),
      ),
    );
  }
}
