import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techie_ai/service/chat_service.dart';
import 'budget_result_screen.dart';

class OptionsScreen extends StatefulWidget {
  @override
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
                        _submitSelection(context, selectedPcType);
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
                  boxShadow: [
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Budget',
                        hintText: 'Enter your budget in USD',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitBudget(context, budgetController.text);
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

  void _submitSelection(BuildContext context, String pcType) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setPcType(pcType);

    setState(() {
      showBudgetBox = true;
    });
  }

  void _submitBudget(BuildContext context, String budget) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setBudget(budget);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetResultScreen(budget: budget),
      ),
    );
  }
}
