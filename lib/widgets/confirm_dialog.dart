import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.confirmText,
    required this.confirmAction,
  });

  final String confirmText;
  final Function confirmAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar'),
      content: Text(confirmText),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            confirmAction();
            Navigator.pop(context);
          },
          child: const Text('Sí'),
        ),
      ],
    );
  }
}
