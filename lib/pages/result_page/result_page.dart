// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'components_table.dart';
import 'installation_instructions.dart';
import 'balance_sheet.dart';
import 'pdf_generator.dart';

class ResultPage extends StatelessWidget {
  final Map<String, Map<String, String?>> selectedComponents;
  final double initialBudget;

  const ResultPage({
    super.key,
    required this.selectedComponents,
    required this.initialBudget,
  });

  double calculateTotalCost() {
    double total = 0.0;
    selectedComponents.forEach((componentType, details) {
      if (details.containsKey('price')) {
        String priceString = details['price'] ?? '0';
        total +=
            double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0.0;
      }
    });
    return total;
  }

  Future<Uint8List> generatePdf() async {
    double totalCost = calculateTotalCost();
    return PdfGenerator.generatePdf(
        selectedComponents, initialBudget, totalCost);
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = calculateTotalCost();
    double remainingBudget = initialBudget - totalCost;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Components'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ComponentsTable(
                selectedComponents: selectedComponents,
                screenWidth: screenWidth),
            const SizedBox(height: 20),
            const InstallationInstructions(),
            const SizedBox(height: 20),
            BalanceSheet(
              totalCost: totalCost,
              initialBudget: initialBudget,
              remainingBudget: remainingBudget,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pdfData = await generatePdf();
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdfData,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Print Document'),
            ),
          ],
        ),
      ),
    );
  }
}
