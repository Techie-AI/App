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
      _showComponentSelectionDialog(
          componentType, name, priceString, link, price);
    } else {
      var removed = selectedComponents.remove(componentType);
      if (removed != null) {
        var priceString = removed['price'] ?? '0';
        double price = double.tryParse(priceString) ?? 0.0;
        updateBudget(price, false);
      }
    }
  }

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
          backgroundColor: Color.fromARGB(255, 29, 30, 32),
          foregroundColor: Color.fromARGB(255, 236, 242, 255)),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
              ),
            ),
            const SizedBox(height: 20),
            ComponentOptionButtons(
              showImportant: showImportant,
              onToggle: toggleComponentView,
              onNext: handleNext,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
