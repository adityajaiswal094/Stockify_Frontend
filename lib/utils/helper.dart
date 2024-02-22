import 'package:flutter/material.dart';

void showDialogMessage(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      });
}
