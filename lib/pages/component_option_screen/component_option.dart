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
        String? link = componentData[componentType].firstWhere(
          (option) => option['name'] == name,
          orElse: () => {},
        )['link'];

        selectedComponents[componentType] = {
          'name': name,
          'price': priceString,
          'link': link,
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
    if (showImportant) {
      // Check if at least one important component is selected
      final importantComponents = [
        'cpu',
        'gpu',
        'motherboard',
        'memory',
        'storage'
      ];
      bool hasSelectedImportant = importantComponents.any(
        (type) => selectedComponents.containsKey(type),
      );

      if (!hasSelectedImportant) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one important component'),
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
                            : keys;

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
                                componentData[componentType] ?? [],
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
            Center(
              child: ElevatedButton(
                onPressed: handleNext,
                child: Text(showImportant ? 'Next' : 'Get the Result'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
