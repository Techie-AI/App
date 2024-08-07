import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert'; // For jsonDecode

class PdfGenerator {
  static Future<Uint8List> generatePdf(
    Map<String, Map<String, String?>> selectedComponents,
    double initialBudget,
    double totalCost,
  ) async {
    final pdf = pw.Document();

    // Generate the main content of the PDF
    List<pw.Widget> content = [
      pw.Text('Build Summary',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
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
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('Name',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('Price',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
      pw.Text('Component Details',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      // Add details and specs section
      ...selectedComponents.entries.map((entry) {
        final componentType = entry.key;
        final details = entry.value;
        final name = details['name'] ?? 'N/A';
        final description =
            details['description'] ?? 'No description available';
        final specsString = details['specs'] ?? '{}';
        final specs = jsonDecode(specsString) as Map<String, dynamic>;

        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 20),
          padding: const pw.EdgeInsets.all(8.0),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey),
            borderRadius: pw.BorderRadius.circular(4.0),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('$componentType: $name',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text('Description: $description',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text('Specifications:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ...specs.entries
                  .map((entry) => pw.Text('${entry.key}: ${entry.value}',
                      style: const pw.TextStyle(fontSize: 14)))
                  .toList(),
            ],
          ),
        );
      }).toList(),
      pw.SizedBox(height: 20),
      pw.Text('Installation Instructions',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Text(
        '1. Install the CPU onto the motherboard.\n'
        '2. Install the CPU cooler.\n'
        '3. Install the RAM into the RAM slots.\n'
        '4. Attach the storage devices (SSD/HDD).\n'
        '5. Connect the power supply to the motherboard, CPU, and other components.\n'
        '6. Install the GPU into the PCI-E slot.\n'
        '7. Connect all necessary cables (data, power, peripheral).\n'
        '8. Double-check all connections and secure cables for good airflow.\n'
        '9. Power on the system and enter BIOS to check if all components are recognized.\n',
        style: const pw.TextStyle(fontSize: 16),
      ),
      pw.SizedBox(height: 20),
      pw.Text('Balance Sheet',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
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
              color: initialBudget >= 0 ? PdfColors.green : PdfColors.red,
            ),
          ),
          pw.Text(
            'Rs${initialBudget >= 0 ? initialBudget : 0}',
            style: pw.TextStyle(
              fontSize: 18,
              color: initialBudget >= 0 ? PdfColors.green : PdfColors.red,
            ),
          ),
        ],
      ),
    ];

    // Generate links table
    List<pw.Widget> linksTable = [
      pw.SizedBox(height: 20),
      pw.Text('Links',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
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
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('Link',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                  child: pw.Text(details['link'] ?? 'No link available'),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    ];

    // Add pages to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => content,
      ),
    );

    // Add links table as a separate page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => linksTable,
      ),
    );

    return pdf.save();
  }
}
