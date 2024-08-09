// component_option.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../result_page/result_page.dart';
import '../../service/description_provider.dart';
import 'component_selection_dialog.dart';
import 'component_view.dart';
import 'component_option_buttons.dart';
import 'package:provider/provider.dart';

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
    if (value != null) {
      var parts = value.split(' - ₹');
      var name = parts[0];
      var priceString = parts[1];
      double price = double.tryParse(priceString) ?? 0.0;

      List<dynamic> options = componentData[componentType]['options'] ?? [];
      var option = options.firstWhere(
        (option) => option['name'] == name,
        orElse: () => {},
      );

      String? link = option['link'];

      // Directly update the selected component and budget
      setState(() {
        selectedComponents[componentType] = {
          'name': name,
          'price': priceString,
          'link': link,
        };
        updateBudget(price, true);
      });
    } else {
      var removed = selectedComponents.remove(componentType);
      if (removed != null) {
        var priceString = removed['price'] ?? '0';
        double price = double.tryParse(priceString) ?? 0.0;
        updateBudget(price, false);
      }
    }
  }

  // Re-add the `_showComponentSelectionDialog` method for the "More Info" button
  void _showComponentSelectionDialog(String componentType, String name,
      String priceString, String? link, double price) async {
    final descriptionProvider =
        Provider.of<DescriptionProvider>(context, listen: false);
    final response =
        await descriptionProvider.getComponentDescription(name, priceString);

    // Handle the dialog content and state
    final dialogContent =
        await getDialogContent(response, name, priceString, link);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ComponentSelectionDialog(
          name: name,
          priceString: priceString,
          link: link,
          description: dialogContent['description'] ?? '',
          specs: dialogContent['specs'] ?? {},
          onConfirm: () {
            setState(() {
              selectedComponents[componentType] = {
                'name': name,
                'price': priceString,
                'link': link,
                'description': dialogContent['description'] ?? '',
                'specs': jsonEncode(dialogContent['specs'] ?? {}),
              };
              updateBudget(price, true);
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>> getDialogContent(
      String response, String name, String priceString, String? link) async {
    Map<String, dynamic> dialogContent = {};
    try {
      final data = jsonDecode(response) as Map<String, dynamic>;
      dialogContent['description'] = data['description'] ?? '';
      final specsData = data['specs'];
      if (specsData is Map<String, dynamic>) {
        dialogContent['specs'] = Map<String, String>.from(specsData);
      } else {
        throw Exception('Invalid specs format');
      }
    } catch (e) {
      print("Error parsing response: $e");
      dialogContent['description'] =
          'An error occurred while fetching the description.';
    }
    return dialogContent;
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
      backgroundColor: const Color.fromARGB(255, 29, 30, 32),
      foregroundColor: const Color.fromARGB(255, 236, 242, 255),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double availableHeight = constraints.maxHeight - 200; // Adjust based on other widgets
          double cardHeight = (availableHeight / (showImportant ? 4 : 6)).clamp(100.0, 200.0); // Set a min and max height

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Based on your budget, here are some recommendations:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  showImportant
                      ? 'Important Components'
                      : 'Non-Important Components',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ComponentView(
                  componentData: componentData,
                  showImportant: showImportant,
                  selectedComponents: selectedComponents,
                  onComponentSelection: handleComponentSelection,
                  onMoreInfo: (String componentType) {}, // Optional callback
                  cardHeight: cardHeight, // Pass the calculated height
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200, // Set a fixed height for the box
                child: ListView.builder(
                  itemCount: selectedComponents.length,
                  itemBuilder: (context, index) {
                    String componentType = selectedComponents.keys.elementAt(index);
                    Map<String, String?> component =
                        selectedComponents[componentType]!;
                    return ListTile(
                      title: Text(
                        '${component['name']} - ₹${component['price']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showComponentSelectionDialog(
                            componentType,
                            component['name']!,
                            component['price']!,
                            component['link'],
                            double.tryParse(component['price']!) ?? 0.0,
                          );
                        },
                        child: const Text('More Info'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ComponentOptionButtons(
                showImportant: showImportant,
                onToggle: toggleComponentView,
                onNext: handleNext,
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    ),
    backgroundColor: Colors.black,
  );
}
}