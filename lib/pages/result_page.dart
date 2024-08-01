// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart'; // Import for handling links

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
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    double totalCost = calculateTotalCost();
    double remainingBudget = initialBudget - totalCost;

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text('Build Summary',
              style: pw.TextStyle(font: boldFont, fontSize: 24)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Component', 'Name', 'Price', 'Link'],
            data: selectedComponents.entries.map((entry) {
              var details = entry.value;
              return [
                entry.key.toUpperCase(),
                details['name'] ?? 'Not selected',
                '₹${details['price'] ?? '0'}',
                details['link'] ?? 'N/A',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Installation Instructions',
              style: pw.TextStyle(font: boldFont, fontSize: 22)),
          pw.SizedBox(height: 10),
          pw.Text(
            '1. Install the CPU onto the motherboard.\n'
            '   - Open the CPU socket lever.\n'
            '   - Align the CPU with the socket using the notches.\n'
            '   - Gently place the CPU into the socket and secure it with the lever.\n'
            '2. Install the CPU cooler.\n'
            '   - Apply thermal paste to the CPU if needed.\n'
            '   - Attach the cooler to the CPU and secure it with the provided brackets.\n'
            '   - Connect the cooler’s power cable to the motherboard.\n'
            '3. Install the RAM into the RAM slots.\n'
            '   - Open the RAM slot levers.\n'
            '   - Align the RAM module with the slot and press down firmly until it clicks.\n'
            '4. Attach the storage devices (SSD/HDD).\n'
            '   - Place the storage devices into the appropriate bays or slots.\n'
            '   - Secure them with screws if needed.\n'
            '   - Connect the data and power cables to the storage devices.\n'
            '5. Connect the power supply to the motherboard, CPU, and other components.\n'
            '   - Attach the 24-pin ATX power connector to the motherboard.\n'
            '   - Connect the 8-pin CPU power connector.\n'
            '   - Connect power cables to the GPU, storage devices, and any additional components.\n'
            '6. Install the GPU into the PCI-E slot.\n'
            '   - Remove the corresponding backplate(s) on the case.\n'
            '   - Insert the GPU into the PCI-E slot and secure it with screws.\n'
            '   - Connect the GPU power cables.\n'
            '7. Connect all necessary cables (front panel, USB, audio, etc.) and power on the system.\n'
            '   - Connect front panel connectors to the motherboard.\n'
            '   - Connect USB, audio, and any other necessary cables.\n'
            '   - Double-check all connections and secure any loose cables with cable ties.\n'
            '   - Power on the system and ensure all components are recognized and functioning correctly.',
            style: pw.TextStyle(font: font, fontSize: 16),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Balance Sheet',
              style: pw.TextStyle(font: boldFont, fontSize: 22)),
          pw.SizedBox(height: 10),
          pw.Text(
            'Total Cost: ₹${totalCost.toStringAsFixed(2)}\n'
            'Initial Budget: ₹${initialBudget.toStringAsFixed(2)}\n'
            'Remaining Budget: ₹${remainingBudget.toStringAsFixed(2)}',
            style: pw.TextStyle(font: font, fontSize: 18),
          ),
        ],
      ),
    );

    return pdf.save();
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
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(80),
                3: FixedColumnWidth(100),
              },
              children: [
                const TableRow(
                  children: [
                    Text('Component',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Price',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Link', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 20),
            const Text(
              'Installation Instructions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Install the CPU onto the motherboard.\n'
              '2. Install the CPU cooler.\n'
              '3. Install the RAM into the RAM slots.\n'
              '4. Attach the storage devices (SSD/HDD).\n'
              '5. Connect the power supply to the motherboard, CPU, and other components.\n'
              '6. Install the GPU into the PCI-E slot.\n'
              '7. Connect all necessary cables (front panel, USB, audio, etc.) and power on the system.\n',
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
            ElevatedButton(
              onPressed: () async {
                final pdfData = await generatePdf();
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdfData,
                );
              },
              child: const Text('Print Document'),
            ),
          ],
        ),
      ),
    );
  }
}
