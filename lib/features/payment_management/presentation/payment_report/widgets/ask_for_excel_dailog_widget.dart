import 'package:flutter/material.dart';

Future<String?> askForExcelName(BuildContext context) {
  final controller = TextEditingController(text: "");

  final theme = Theme.of(context); // capture once for conciseness

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      // AlertDialog already respects ThemeData.* (colors, typography, shapes)
      return AlertDialog(
        // OPTIONAL: if you use a rounded card style globally,
        // AlertDialog uses DialogTheme.shape. Otherwise customize here:
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Save as Excel'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => Navigator.of(ctx).pop(controller.text),
          decoration: const InputDecoration(
            labelText: 'File name',
            suffixText: '.xlsx',
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(ctx).pop(null),
          ),
          TextButton(
            // Uses the primary color defined in your ColorScheme
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
            child: const Text('SAVE'),
            onPressed: () => Navigator.of(ctx).pop(controller.text),
          ),
        ],
      );
    },
  );
}
