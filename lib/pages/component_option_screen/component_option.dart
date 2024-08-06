import 'package:flutter/material.dart';
import 'build_option_card.dart';
import '../result_page/result_page.dart';

class ComponentOption extends StatefulWidget {
  final String budget;
  final Map<String, dynamic> data;

  const ComponentOption({super.key, required this.budget, required this.data});

  @override
  _ComponentOptionState createState() => _ComponentOptionState();
}

class _ComponentOptionState extends State<ComponentOption> {
  late double currentBudget;
  late Map<String, dynamic> componentData;
  final Map<String, Map<String, String?>> selectedComponents = {};
  bool showImportant = true;

  @override
  void initState() {
    super.initState();
    currentBudget = double.tryParse(widget.budget) ?? 0.0;
    componentData = widget.data['components'] ?? {};
  }

  void updateBudget(double price, bool isSelected) {
    setState(() {
      currentBudget += isSelected ? price : -price;
    });
  }

  void handleComponentSelection(String componentType, String? value) {
    setState(() {
      if (value != null) {
        var parts = value.split(' - ₹');
        var name = parts[0];
        var priceString = parts[1];
        double price = double.tryParse(priceString) ?? 0.0;

        // Access the options list from the component data
        List<dynamic> options = componentData[componentType]['options'] ?? [];

        // Find the option where the name matches
        var option = options.firstWhere(
          (option) => option['name'] == name,
          orElse: () => {},
        );

        String? link = option['link'];

        selectedComponents[componentType] = {
          'name': name,
          'price': priceString,
          'link': link, // Ensure link is set here
        };

        updateBudget(price, true);
      } else {
        var removed = selectedComponents.remove(componentType);
        if (removed != null) {
          var priceString = removed['price'] ?? '0';
          double price = double.tryParse(priceString) ?? 0.0;
          updateBudget(price, false);
        }
      }
    });
  }

  void navigateToResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          selectedComponents: selectedComponents,
          initialBudget: double.tryParse(widget.budget) ?? 0.0,
        ),
      ),
    );
  }

  void handleNext() {
    final importantComponents = [
      'cpu',
      'gpu',
      'motherboard',
      'memory',
      'storage'
    ];

    if (showImportant) {
      // Check if all important components are selected
      bool allImportantSelected = importantComponents.every(
        (type) => selectedComponents.containsKey(type),
      );

      if (!allImportantSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select all important components'),
          ),
        );
        return;
      }

      setState(() {
        showImportant = false;
      });
    } else {
      navigateToResultPage();
    }
  }

  void toggleComponentView() {
    setState(() {
      showImportant = !showImportant;
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
                const Expanded(
                  child: Text(
                    'Based on your budget, here are some recommendations:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
            Center(
              child: Text(
                showImportant
                    ? 'Important Components'
                    : 'Non-Important Components',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: componentData.isNotEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        final keys = componentData.keys.toList();
                        final importantKeys = [
                          'cpu',
                          'gpu',
                          'motherboard',
                          'memory',
                          'storage'
                        ];
                        final displayedKeys = showImportant
                            ? importantKeys
                                .where((key) => keys.contains(key))
                                .toList()
                            : keys
                                .where((key) => !importantKeys.contains(key))
                                .toList();

                        if (constraints.maxWidth < 600) {
                          return ListView.builder(
                            itemCount: displayedKeys.length,
                            itemBuilder: (context, index) {
                              String componentType = displayedKeys[index];
                              return buildOptionCard(
                                context,
                                componentType.toUpperCase(),
                                componentData[componentType]['options'] ?? [],
                                selectedComponents,
                                (String? value) {
                                  handleComponentSelection(
                                      componentType, value);
                                },
                              );
                            },
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                            ),
                            itemCount: displayedKeys.length,
                            itemBuilder: (context, index) {
                              String componentType = displayedKeys[index];
                              return buildOptionCard(
                                context,
                                componentType.toUpperCase(),
                                componentData[componentType]['options'] ?? [],
                                selectedComponents,
                                (String? value) {
                                  handleComponentSelection(
                                      componentType, value);
                                },
                              );
                            },
                          );
                        }
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: toggleComponentView,
                  child: Text(
                      showImportant ? 'Show Non-Important' : 'Show Important'),
                ),
                ElevatedButton(
                  onPressed: handleNext,
                  child: Text(showImportant ? 'Next' : 'Get the Result'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
