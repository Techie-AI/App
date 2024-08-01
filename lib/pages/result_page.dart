import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, String?> selectedComponents;

  const ResultPage({super.key, required this.selectedComponents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Components'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: selectedComponents.length,
          itemBuilder: (context, index) {
            String componentType = selectedComponents.keys.elementAt(index);
            String? componentDetails = selectedComponents[componentType];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  componentType.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  componentDetails ?? 'No selection',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
