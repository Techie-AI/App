import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<Uint8List> generatePdf(
    Map<String, Map<String, String?>> selectedComponents,
    double initialBudget,
    double totalCost,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Build Summary',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Component',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Name',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Price',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...selectedComponents.entries.map((entry) {
                    var details = entry.value;
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(entry.key.toUpperCase()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(details['name'] ?? 'Not selected'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('${details['price'] ?? '0'}'),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Installation Instructions',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
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
                '7. Connect all necessary cables (data, power, peripheral).\n'
                '   - Connect the case’s front panel connectors to the motherboard.\n'
                '   - Attach any additional peripherals and case fans.\n'
                '8. Double-check all connections and secure cables for good airflow.\n'
                '9. Power on the system and enter BIOS to check if all components are recognized.\n',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Balance Sheet',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total Cost:',
                    style: const pw.TextStyle(fontSize: 18),
                  ),
                  pw.Text(
                    'Rs$totalCost',
                    style: const pw.TextStyle(fontSize: 18),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Initial Budget:',
                    style: const pw.TextStyle(fontSize: 18),
                  ),
                  pw.Text(
                    'Rs$initialBudget',
                    style: const pw.TextStyle(fontSize: 18),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    initialBudget >= 0 ? 'Remaining Budget:' : 'Over Budget:',
                    style: pw.TextStyle(
                      fontSize: 18,
                      color:
                          initialBudget >= 0 ? PdfColors.green : PdfColors.red,
                    ),
                  ),
                  pw.Text(
                    'Rs$initialBudget',
                    style: pw.TextStyle(
                      fontSize: 18,
                      color:
                          initialBudget >= 0 ? PdfColors.green : PdfColors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
