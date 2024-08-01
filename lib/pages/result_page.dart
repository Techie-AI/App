import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, Map<String, String?>> selectedComponents;
  final double initialBudget;

  const ResultPage(
      {super.key,
      required this.selectedComponents,
      required this.initialBudget});

  double calculateTotalCost() {
    double total = 0.0;
    selectedComponents.forEach((componentType, details) {
      if (details != null && details.containsKey('price')) {
        String priceString = details['price'] ?? '0';
        total +=
            double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0.0;
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = calculateTotalCost();
    double remainingBudget = initialBudget - totalCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Components'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Build Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...selectedComponents.entries.map((entry) {
              var details = entry.value;
              if (details != null) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${details['name'] ?? 'Not selected'}'),
                        Text('Price: ₹${details['price'] ?? '0'}'),
                        const SizedBox(height: 10),
                        if (details['link'] != null)
                          ElevatedButton(
                            onPressed: () {
                              _launchURL(context, details['link']!);
                            },
                            child: const Text('Purchase / More Info'),
                          ),
                      ],
                    ),
                  ),
                );
              } else {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Not selected'),
                  ),
                );
              }
            }),
            const SizedBox(height: 20),
            const Text(
              'Installation Instructions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Install the CPU onto the motherboard.\n'
              '2. Install the RAM into the RAM slots.\n'
              '3. Attach the storage devices.\n'
              '4. Connect the power supply to the motherboard, CPU, and other components.\n'
              '5. Install the GPU into the PCI-E slot.\n'
              '6. Connect all necessary cables and power on the system.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Balance Sheet',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Cost: ₹${totalCost.toStringAsFixed(2)}\n'
              'Initial Budget: ₹${initialBudget.toStringAsFixed(2)}\n'
              'Remaining Budget: ₹${remainingBudget.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) {
    // You can use a package like `url_launcher` to open the URL
    // Example:
    // import 'package:url_launcher/url_launcher.dart';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    // For now, we'll just print the URL
    print('Opening URL: $url');
  }
}
