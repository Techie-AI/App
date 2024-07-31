import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/response_provider.dart'; // Ensure this path is correct

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

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
                _sendRequest(context, selectedPcType);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendRequest(BuildContext context, String pcType) async {
    final responseProviderConst =
        Provider.of<ResponseProvider>(context, listen: false);

    // Send the PC type request
    await responseProviderConst.sendPcTypeRequest(pcType);

    // Optionally, handle UI updates or navigate to another screen
    // For example, show a loading indicator or navigate to a result screen
  }
}
