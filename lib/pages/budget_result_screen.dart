import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class BudgetResultScreen extends StatefulWidget {
  final String budget;

  BudgetResultScreen({required this.budget});

  @override
  _BudgetResultScreenState createState() => _BudgetResultScreenState();
}

class _BudgetResultScreenState extends State<BudgetResultScreen> {
  late double currentBudget;
  String? selectedCpu;
  String? selectedRam;
  String? selectedOther;
  Map<String, dynamic> componentData = {};

  @override
  void initState() {
    super.initState();
    currentBudget = double.tryParse(widget.budget) ?? 0.0;
    _loadComponentData();
  }

  Future<void> _loadComponentData() async {
    try {
      final String response = await rootBundle.loadString('JSON/flash.json');
      final data = json.decode(response);
      setState(() {
        componentData = data['components'];
      });
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  void updateBudget(double price) {
    setState(() {
      currentBudget -= price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Based on your budget, here are some recommendations:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Budget: ₹${currentBudget.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (componentData.isNotEmpty) ...[
              buildOptionCard(
                context,
                'CPU',
                componentData['cpu'],
                (String? value) {
                  setState(() {
                    selectedCpu = value;
                    double price = double.parse(value!.split(' - ₹')[1].replaceAll(',', ''));
                    updateBudget(price);
                  });
                },
              ),
              const SizedBox(height: 20),
              buildOptionCard(
                context,
                'RAM',
                componentData['ram'],
                (String? value) {
                  setState(() {
                    selectedRam = value;
                    double price = double.parse(value!.split(' - ₹')[1].replaceAll(',', ''));
                    updateBudget(price);
                  });
                },
              ),
              const SizedBox(height: 20),
              buildOptionCard(
                context,
                'Other Specs',
                componentData['gpu'], // Replace with the appropriate component key
                (String? value) {
                  setState(() {
                    selectedOther = value;
                    double price = double.parse(value!.split(' - ₹')[1].replaceAll(',', ''));
                    updateBudget(price);
                  });
                },
              ),
            ] else ...[
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildOptionCard(
      BuildContext context, String title, List<dynamic> options, ValueChanged<String?> onChanged) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String?>(
              isExpanded: true,
              value: options.map((e) => e['name']).contains(selectedCpu) ? selectedCpu : null,
              hint: const Text('Select an option'),
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((dynamic option) {
                return DropdownMenuItem<String>(
                  value: '${option['name']} - ₹${option['price']}',
                  child: Text('${option['name']} - ₹${option['price']}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
