import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techie_ai/pages/budget_result_screen.dart';
import 'package:techie_ai/service/response_provider.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  String selectedPcType = 'Gaming PC (High)';
  bool showBudgetBox = false;
  TextEditingController budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your PC Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select the type of PC you want to build:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: selectedPcType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPcType = newValue!;
                        });
                      },
                      items: <String>[
                        'Gaming PC (High)',
                        'Office PC (Mid)',
                        'Personal PC (Low)'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitSelection();
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (showBudgetBox)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter your budget:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Budget',
                        hintText: 'Enter your budget in INR',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitBudget();
                      },
                      child: const Text('Submit Budget'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submitSelection() {
    setState(() {
      showBudgetBox = true;
    });
  }

  void _submitBudget() async {
    final responseProvider =
        Provider.of<ResponseProvider>(context, listen: false);
    final budget = budgetController.text;

    // Fetch the data from the model
    final data =
        await responseProvider.sendPcTypeRequest(selectedPcType, budget);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetResultScreen(budget: budget, data: data),
      ),
    );
  }
}
