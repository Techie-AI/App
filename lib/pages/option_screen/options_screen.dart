import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../component_option_screen/component_option.dart';
import '../../service/response_provider.dart';
import 'pc_option.dart';
import 'loading_indicator.dart';
import 'currency_text_input_formatter.dart';

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
  String warningMessage = '';

  bool get isSubmitEnabled {
    final budget = double.tryParse(
        budgetController.text.replaceAll(',', '').replaceAll('₹', '').trim());
    if (selectedPcType.isEmpty || budget == null) {
      return false;
    }
    switch (selectedPcType) {
      case 'Gaming PC (High)':
        return budget > 50000;
      case 'Office PC (Mid)':
        return budget > 30000;
      case 'Personal PC (Low)':
        return budget > 15000;
      default:
        return false;
    }
  }

  void updateWarningMessage() {
    final budget = double.tryParse(
        budgetController.text.replaceAll(',', '').replaceAll('₹', '').trim());
    if (selectedPcType.isEmpty) {
      warningMessage = '';
      return;
    }

    if (budget == null) {
      warningMessage = 'Please enter a valid budget.';
    } else {
      switch (selectedPcType) {
        case 'Gaming PC (High)':
          warningMessage =
              budget > 50000 ? '' : 'Minimum budget for Gaming PC is ₹50,000.';
          break;
        case 'Office PC (Mid)':
          warningMessage =
              budget > 30000 ? '' : 'Minimum budget for Office PC is ₹30,000.';
          break;
        case 'Personal PC (Low)':
          warningMessage = budget > 15000
              ? ''
              : 'Minimum budget for Personal PC is ₹15,000.';
          break;
        default:
          warningMessage = '';
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Your PC Type',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(221, 32, 32, 32),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;

                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width < 600 ? width : 600,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select the type of PC you want to build:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: width,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: pcOptions.length,
                                  itemBuilder: (context, index) {
                                    final option = pcOptions[index];
                                    return MouseRegion(
                                      onEnter: (_) {
                                        setState(() {
                                          option.setHovered(true);
                                        });
                                      },
                                      onExit: (_) {
                                        setState(() {
                                          option.setHovered(false);
                                        });
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPcType = option.name;
                                            updateWarningMessage();
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            color: selectedPcType == option.name
                                                ? Color.fromARGB(
                                                        255, 0, 90, 226)
                                                    .withOpacity(0.3)
                                                : option.isHovered()
                                                    ? Colors.grey[700]
                                                    : Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: option.isHovered()
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.teal
                                                          .withOpacity(0.5),
                                                      blurRadius: 8,
                                                      spreadRadius: 2,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(option.image,
                                                    height: 90),
                                                const SizedBox(height: 10),
                                                Text(
                                                  option.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: width < 600 ? width : 600,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.grey[850],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Enter your budget:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '₹',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: budgetController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            CurrencyTextInputFormatter(),
                                          ],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          onChanged: (value) {
                                            updateWarningMessage();
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter your budget',
                                            hintStyle: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (warningMessage.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        warningMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isSubmitEnabled ? () => _submit() : null,
                          child: const Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                isSubmitEnabled ? Colors.teal : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (isLoading)
            Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const Center(
                  child: LoadingIndicator(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _submit() async {
    final responseProvider =
        Provider.of<ResponseProvider>(context, listen: false);
    final budget =
        budgetController.text.replaceAll(',', '').replaceAll('₹', '').trim();

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
          builder: (context) => ComponentOption(
            budget: budget,
            data: data,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch components: $e'),
        ),
      );
    }
  }
}
