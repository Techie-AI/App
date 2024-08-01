import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techie_ai/models/loading_indicator.dart';
import '../models/pc_options_model.dart';
import 'component_option_screen.dart';
import '../service/response_provider.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  List<PcOption> pcOptions = [
    PcOption(name: 'Gaming PC (High)', image: 'assets/gaming_pc.png'),
    PcOption(name: 'Office PC (Mid)', image: 'assets/office_pc.png'),
    PcOption(name: 'Personal PC (Low)', image: 'assets/personal_pc.png'),
  ];
  String selectedPcType = '';
  TextEditingController budgetController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your PC Type'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth * 0.9;

                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select the type of PC you want to build:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: width,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: pcOptions.length,
                            itemBuilder: (context, index) {
                              final option = pcOptions[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPcType = option.name;
                                  });
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: selectedPcType == option.name
                                      ? Colors.blue.withOpacity(0.3)
                                      : Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(option.image, height: 50),
                                      const SizedBox(height: 10),
                                      Text(option.name, textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: width,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Enter your budget:',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _submit();
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: LoadingIndicator(),
            ),
        ],
      ),
    );
  }

  void _submit() async {
    final responseProvider =
        Provider.of<ResponseProvider>(context, listen: false);
    final budget = budgetController.text;

    if (selectedPcType.isEmpty || budget.isEmpty) {
      // Show an error message if either field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PC type and enter a budget')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final data =
          await responseProvider.sendPcTypeRequest(selectedPcType, budget);

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComponentOption(budget: budget, data: data),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }
}
