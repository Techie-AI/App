import 'package:flutter/material.dart';

Widget buildOptionCard(
  BuildContext context,
  String title,
  List<dynamic> options,
  Map<String, Map<String, String?>> selectedComponents,
  ValueChanged<String?> onChanged, {required void Function() onMoreInfo}
) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: Colors.grey[850], // Dark card background color
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Set to min to fit content
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Title text color
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the width based on available space
              double width = constraints.maxWidth;
              int crossAxisCount =
                  (width / 200).floor(); // Adjust based on desired card width

              return Wrap(
                spacing: 8.0, // Horizontal space between options
                runSpacing: 8.0, // Vertical space between rows
                children: options.map((option) {
                  var value = '${option['name']} - ₹${option['price']}';
                  bool isSelected =
                      selectedComponents[title.toLowerCase()] != null &&
                          selectedComponents[title.toLowerCase()]!['name'] ==
                              option['name'];

                  return Container(
                    width: (width / crossAxisCount) - 16, // Width of each option box
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blueAccent
                          : Color.fromARGB(255, 34, 34, 34), // Selected color
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blueAccent
                            : Colors.grey, // Border color
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => onChanged(isSelected ? null : value),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Color.fromARGB(
                                  225, 255, 255, 255), // Text color
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    ),
  );
}
