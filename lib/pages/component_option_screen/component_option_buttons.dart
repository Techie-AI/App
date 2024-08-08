// component_option_buttons.dart

import 'package:flutter/material.dart';

class ComponentOptionButtons extends StatelessWidget {
  final bool showImportant;
  final VoidCallback onToggle;
  final VoidCallback onNext;

  const ComponentOptionButtons({
    super.key,
    required this.showImportant,
    required this.onToggle,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: onToggle,
          child: Text(showImportant ? 'Show Non-Important' : 'Show Important'),
        ),
        ElevatedButton(
          onPressed: onNext,
          child: Text(showImportant ? 'Next' : 'Get the Result'),
        ),
      ],
    );
  }
}
