// component_selection_dialog.dart

import 'package:flutter/material.dart';

class ComponentSelectionDialog extends StatelessWidget {
  final String name;
  final String priceString;
  final String? link;
  final String description;
  final Map<String, String> specs;
  final VoidCallback onConfirm;

  const ComponentSelectionDialog({
    super.key,
    required this.name,
    required this.priceString,
    required this.link,
    required this.description,
    required this.specs,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text('Confirm Selection',
          style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Component: $name',
                style: const TextStyle(color: Colors.white)),
            Text('Price: ₹$priceString',
                style: const TextStyle(color: Colors.white)),
            if (link != null) ...[
              const SizedBox(height: 10),
              Text('Link: $link', style: const TextStyle(color: Colors.white)),
            ],
            const SizedBox(height: 10),
            const Text('Description:', style: TextStyle(color: Colors.white)),
            Text(description, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            const Text('Specifications:',
                style: TextStyle(color: Colors.white)),
            ...specs.entries.map(
              (entry) => Text('${entry.key}: ${entry.value}',
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Confirm', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
