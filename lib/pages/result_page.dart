import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

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
      if (details != null && details.containsKey('price')) {
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
          ...selectedComponents.entries.map((entry) {
            var details = entry.value;
            return pw.Container(
              margin: pw.EdgeInsets.symmetric(vertical: 10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    entry.key.toUpperCase(),
                    style: pw.TextStyle(font: boldFont, fontSize: 18),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text('Name: ${details['name'] ?? 'Not selected'}',
                      style: pw.TextStyle(font: font)),
                  pw.Text('Price: ₹${details['price'] ?? '0'}',
                      style: pw.TextStyle(font: font)),
                  if (details['link'] != null)
                    pw.Padding(
                      padding: pw.EdgeInsets.only(top: 10),
                      child: pw.Text('Link: ${details['link']!}',
                          style: pw.TextStyle(font: font)),
                    ),
                ],
              ),
            );
          }).toList(),
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
            ...selectedComponents.entries.map((entry) {
              var details = entry.value;
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
                        Text('Link: ${details['link']!}'),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Installation Instructions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
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
