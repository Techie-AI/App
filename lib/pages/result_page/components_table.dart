import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ComponentsTable extends StatelessWidget {
  final Map<String, Map<String, String?>> selectedComponents;
  final double screenWidth;

  const ComponentsTable({
    super.key,
    required this.selectedComponents,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 82, 150).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Build Summary',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 122, 223)),
          ),
          const SizedBox(height: 20),
          Table(
            border:
                TableBorder.all(color: const Color.fromARGB(255, 0, 82, 150)),
            columnWidths: screenWidth < 600
                ? {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                  }
                : {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                  },
            children: [
              const TableRow(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 82, 150),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Component',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Price',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Link',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
              ...selectedComponents.entries.map((entry) {
                var details = entry.value;
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(entry.key.toUpperCase()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(details['name'] ?? 'Not selected'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('₹${details['price'] ?? '0'}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (details['link'] != null) {
                            final url = details['link']!;
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          }
                        },
                        child: Text(
                          details['link'] ?? 'N/A',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
