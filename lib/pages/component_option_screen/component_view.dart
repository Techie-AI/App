// component_view.dart

import 'package:flutter/material.dart';
import 'build_option_card.dart';

class ComponentView extends StatelessWidget {
  final Map<String, dynamic> componentData;
  final bool showImportant;
  final Map<String, Map<String, String?>> selectedComponents;
  final void Function(String, String?) onComponentSelection;

  const ComponentView({
    super.key,
    required this.componentData,
    required this.showImportant,
    required this.selectedComponents,
    required this.onComponentSelection, required void Function(String componentType) onMoreInfo, required double cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final importantKeys = ['cpu', 'gpu', 'motherboard', 'memory', 'storage'];
    final displayedKeys = showImportant
        ? importantKeys.where((key) => componentData.containsKey(key)).toList()
        : componentData.keys
            .where((key) => !importantKeys.contains(key))
            .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust the number of columns based on the available width
        int columns = constraints.maxWidth < 600 ? 1 : 2;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio:
                constraints.maxWidth / (constraints.maxHeight / 2),
          ),
          itemCount: displayedKeys.length,
          itemBuilder: (context, index) {
            String key = displayedKeys[index];
            var component = componentData[key];
            if (component != null) {
              return buildOptionCard(
                context,
                key.toUpperCase(),
                component['options'] ?? [],
                selectedComponents,
                (value) => onComponentSelection(key, value), onMoreInfo: () {  },
              );
            }
            return Container(); // Return an empty container if no component is found
          },
        );
      },
    );
  }
}
