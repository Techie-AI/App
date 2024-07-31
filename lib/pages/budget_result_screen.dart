import 'package:flutter/material.dart';

class BudgetResultScreen extends StatefulWidget {
  final String budget;
  final Map<String, dynamic> data;

  const BudgetResultScreen(
      {super.key, required this.budget, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _BudgetResultScreenState createState() => _BudgetResultScreenState();
}

class _BudgetResultScreenState extends State<BudgetResultScreen> {
  late double currentBudget;
  Map<String, dynamic> componentData = {};
  Map<String, String?> selectedComponents = {};

  @override
  void initState() {
    super.initState();
    currentBudget = double.tryParse(widget.budget) ?? 0.0;
    componentData = widget.data['components'] ?? {};
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
              ...componentData.keys.map((componentType) {
                return Column(
                  children: [
                    buildOptionCard(
                      context,
                      componentType.toUpperCase(),
                      componentData[componentType],
                      (String? value) {
                        setState(() {
                          selectedComponents[componentType] = value;
                          double price = double.parse(
                              value!.split(' - ₹')[1].replaceAll(',', ''));
                          updateBudget(price);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ] else ...[
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildOptionCard(BuildContext context, String title,
      List<dynamic> options, ValueChanged<String?> onChanged) {
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
              value: selectedComponents[title.toLowerCase()],
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
