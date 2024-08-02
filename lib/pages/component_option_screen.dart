import 'package:flutter/material.dart';
import './result_page/result_page.dart';

class ComponentOption extends StatefulWidget {
  final String budget;
  final Map<String, dynamic> data;

  const ComponentOption({super.key, required this.budget, required this.data});

  @override
  _ComponentOptionState createState() => _ComponentOptionState();
}

class _ComponentOptionState extends State<ComponentOption> {
  late double currentBudget;
  Map<String, dynamic> componentData = {};
  Map<String, Map<String, String?>> selectedComponents = {};

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
                        if (constraints.maxWidth < 600) {
                          // Mobile layout (List)
                          return ListView.builder(
                            itemCount: componentData.keys.length,
                            itemBuilder: (context, index) {
                              String componentType =
                                  componentData.keys.elementAt(index);
                              return buildOptionCard(
                                context,
                                componentType.toUpperCase(),
                                componentData[componentType],
                                (String? value) {
                                  setState(() {
                                    if (value != null) {
                                      var parts = value.split(' - ₹');
                                      var name = parts[0];
                                      var priceString = parts[1];
                                      double price =
                                          double.tryParse(priceString) ?? 0.0;
                                      String? link =
                                          componentData[componentType]
                                              .firstWhere(
                                        (option) => option['name'] == name,
                                        orElse: () => {},
                                      )['link'];

                                      bool isSelected =
                                          selectedComponents[componentType] ==
                                              null;

                                      updateBudget(price, !isSelected);

                                      if (isSelected) {
                                        selectedComponents[componentType] = {
                                          'name': name,
                                          'price': priceString,
                                          'link': link,
                                        };
                                      } else {
                                        selectedComponents
                                            .remove(componentType);
                                      }
                                    }
                                  });
                                },
                              );
                            },
                          );
                        } else {
                          // Desktop layout (Grid)
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                            ),
                            itemCount: componentData.keys.length,
                            itemBuilder: (context, index) {
                              String componentType =
                                  componentData.keys.elementAt(index);
                              return buildOptionCard(
                                context,
                                componentType.toUpperCase(),
                                componentData[componentType],
                                (String? value) {
                                  setState(() {
                                    if (value != null) {
                                      var parts = value.split(' - ₹');
                                      var name = parts[0];
                                      var priceString = parts[1];
                                      double price =
                                          double.tryParse(priceString) ?? 0.0;
                                      String? link =
                                          componentData[componentType]
                                              .firstWhere(
                                        (option) => option['name'] == name,
                                        orElse: () => {},
                                      )['link'];

                                      bool isSelected =
                                          selectedComponents[componentType] ==
                                              null;

                                      updateBudget(price, !isSelected);

                                      if (isSelected) {
                                        selectedComponents[componentType] = {
                                          'name': name,
                                          'price': priceString,
                                          'link': link,
                                        };
                                      } else {
                                        selectedComponents
                                            .remove(componentType);
                                      }
                                    }
                                  });
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
                onPressed: () {
                  if (selectedComponents.isNotEmpty) {
                    navigateToResultPage();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least one option'),
                      ),
                    );
                  }
                },
                child: const Text('Get the Result'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionCard(BuildContext context, String title,
      List<dynamic> options, ValueChanged<String?> onChanged) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: options.map((option) {
                var value = '${option['name']} - ₹${option['price']}';
                bool isSelected =
                    selectedComponents[title.toLowerCase()] != null &&
                        selectedComponents[title.toLowerCase()]!['name'] ==
                            option['name'];

                return GestureDetector(
                  onTap: () => onChanged(isSelected ? null : value),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
