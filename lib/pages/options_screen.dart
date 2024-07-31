import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techie_ai/service/chat_service.dart';
// Assuming this is the correct path

class OptionsScreen extends StatefulWidget {
  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  String selectedPcType = 'Gaming PC (High)';

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
    );
  }

  void _submitSelection(BuildContext context, String pcType) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setPcType(pcType);

    // Navigate to another screen or provide feedback
  }
}
