import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';


Future<void> showAppSnack(
    BuildContext context,
    String message, {
      IconData icon = Icons.check_circle,
      Duration duration = const Duration(seconds: 3),
      bool isError = false,
      bool fromTop = false, // ← new flag
    }) async {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  final accent = isError ? scheme.error : scheme.primary;

  await Flushbar(
    // POSITION ─────────────────────────────────────────
    flushbarPosition:
    fromTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    // Give it breathing room from edges / status bar
    margin: fromTop
        ? const EdgeInsets.fromLTRB(16, kToolbarHeight + 8, 16, 0)
        : const EdgeInsets.fromLTRB(16, 0, 16, 16),
    borderRadius: BorderRadius.circular(16),
    // VISUALS ──────────────────────────────────────────
    backgroundColor: scheme.surface,
    boxShadows: [
      BoxShadow(
        blurRadius: 6,
        offset: const Offset(0, 2),
        color: Colors.black.withOpacity(0.08),
      ),
    ],
    icon: Icon(icon, color: accent, size: 28),
    leftBarIndicatorColor: accent,
    duration: duration,
    messageText: Text(
      message,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurface,
      ),
    ),
    mainButton: TextButton(
      style: TextButton.styleFrom(foregroundColor: accent),
      child: const Text('OK'),
      onPressed: () => Navigator.of(context).pop(),
    ),
  ).show(context);
}