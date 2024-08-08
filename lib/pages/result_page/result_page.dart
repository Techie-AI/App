import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'pdf_generator.dart';
import 'components_table.dart';
import 'installation_instructions.dart';
import 'balance_sheet.dart';
import '../dashboard_page.dart'; // Import your DashboardPage

class ResultPage extends StatelessWidget {
  final Map<String, Map<String, String?>>? selectedComponents;
  final double? initialBudget;
  final String? previousResultData;

  const ResultPage({
    super.key,
    required this.selectedComponents,
    required this.initialBudget,
  }) : previousResultData = null;

  const ResultPage.withPreviousData({
    required this.previousResultData,
  })  : selectedComponents = null,
        initialBudget = null;

  double calculateTotalCost() {
    double total = 0.0;
    final components = previousResultData != null
        ? convertToTypedMap(
            jsonDecode(previousResultData!)['selectedComponents'])
        : selectedComponents;

    if (components != null) {
      components.forEach((componentType, details) {
        if (details.containsKey('price')) {
          String priceString = details['price'] ?? '0';
          total +=
              double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                  0.0;
        }
      });
    }
    return total;
  }

  Map<String, Map<String, String?>> convertToTypedMap(
      Map<String, dynamic> data) {
    final Map<String, Map<String, String?>> typedMap = {};

    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        final Map<String, String?> innerMap = {};
        value.forEach((innerKey, innerValue) {
          innerMap[innerKey] = innerValue?.toString();
        });
        typedMap[key] = innerMap;
      }
    });

    return typedMap;
  }

  Future<Uint8List> generatePdf() async {
    double totalCost = calculateTotalCost();
    return PdfGenerator.generatePdf(
      selectedComponents ??
          convertToTypedMap(
              jsonDecode(previousResultData!)['selectedComponents']),
      initialBudget ?? jsonDecode(previousResultData!)['initialBudget'],
      totalCost,
    );
  }

  Future<void> saveResult(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final data = jsonEncode({
      'selectedComponents': selectedComponents ??
          convertToTypedMap(
              jsonDecode(previousResultData!)['selectedComponents']),
      'initialBudget':
          initialBudget ?? jsonDecode(previousResultData!)['initialBudget'],
    });

    String? userName = await showDialog<String>(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[850], // Change background color to grey
      title: const Text('Enter file name', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: 'Name',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white), // Change text color to white
        onSubmitted: (value) {
          Navigator.of(context).pop(value); // Save on Enter
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(nameController.text);
          },
          child: const Text('Save'),
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 46, 173), // Change to blue
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  },
);

    if (userName != null && userName.isNotEmpty) {
      await DatabaseHelper().saveResult(date, userName, data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Result saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final components = previousResultData != null
        ? convertToTypedMap(
            jsonDecode(previousResultData!)['selectedComponents'])
        : selectedComponents;
    final budget =
        initialBudget ?? jsonDecode(previousResultData!)['initialBudget'];
    double totalCost = calculateTotalCost();
    double remainingBudget = budget - totalCost;
    final screenWidth = MediaQuery.of(context).size.width;

    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 0, 46, 173),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Selected Components'),
          backgroundColor: const Color.fromARGB(255, 0, 27, 68),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ComponentsTable(
                selectedComponents:
                    components as Map<String, Map<String, String?>>,
                screenWidth: screenWidth,
                // Add any additional required parameters here
              ),
              const SizedBox(height: 20),
              const InstallationInstructions(),
              const SizedBox(height: 20),
              if (components.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Component Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (screenWidth > 600)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: screenWidth / 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemCount: components.length,
                        itemBuilder: (context, index) {
                          final componentType =
                              components.keys.elementAt(index);
                          final details = components[componentType]!;
                          final name = details['name'] ?? 'N/A';
                          final price = details['price'] ?? 'N/A';
                          final description = details['description'] ??
                              'No description available';
                          final specsString = details['specs'] ?? '{}';
                          final specs = jsonDecode(specsString)
                              as Map<String, dynamic>;

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 82, 150).withOpacity(0.6),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$componentType: $name',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Price: ',
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Description: $description',
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Specifications:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Specification',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Value',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      rows: specs.entries.map((entry) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(
                                              entry.key,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                            DataCell(Text(
                                              entry.value.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: components.length,
                        itemBuilder: (context, index) {
                          final componentType =
                              components.keys.elementAt(index);
                          final details = components[componentType]!;
                          final name = details['name'] ?? 'N/A';
                          final price = details['price'] ?? 'N/A';
                          final description = details['description'] ??
                              'No description available';
                          final specsString = details['specs'] ?? '{}';
                          final specs = jsonDecode(specsString)
                              as Map<String, dynamic>;

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 82, 150),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$componentType: $name',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Price: ',
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Description: $description',
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Specifications:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Specification',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Value',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      rows: specs.entries.map((entry) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(
                                              entry.key,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                            DataCell(Text(
                                              entry.value.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              BalanceSheet(
                initialBudget: budget,
                totalCost: totalCost,
                remainingBudget: remainingBudget,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pdfData = await generatePdf();
                      await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdfData);
                    },
                    child: const Text('Generate PDF'),
                  ),
                  ElevatedButton(
                    onPressed: () => saveResult(context),
                    child: const Text('Save Result'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(name: '',),
                    ),
                  );
                },
                child: const Text('Return to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
