import 'package:flutter/material.dart';

class InstallationInstructions extends StatelessWidget {
  const InstallationInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 82, 150).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Installation Instructions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '1. Install the CPU onto the motherboard.\n'
            '2. Install the CPU cooler.\n'
            '3. Install the RAM into the RAM slots.\n'
            '4. Attach the storage devices (SSD/HDD).\n'
            '5. Connect the power supply to the motherboard, CPU, and other components.\n'
            '6. Install the GPU into the PCI-E slot.\n'
            '7. Connect all necessary cables (data, power, peripheral).\n'
            '8. Double-check all connections and secure cables for good airflow.\n'
            '9. Power on the system and enter BIOS to check if all components are recognized.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
