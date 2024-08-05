import 'package:flutter/material.dart';

Widget buildOptionCard(
  BuildContext context,
  String title,
  List<dynamic> options,
  Map<String, Map<String, String?>> selectedComponents,
  ValueChanged<String?> onChanged,
) {
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
