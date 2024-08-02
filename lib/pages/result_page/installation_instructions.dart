import 'package:flutter/material.dart';

class InstallationInstructions extends StatelessWidget {
  const InstallationInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
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
            '   - Open the CPU socket lever.\n'
            '   - Align the CPU with the socket using the notches.\n'
            '   - Gently place the CPU into the socket and secure it with the lever.\n'
            '2. Install the CPU cooler.\n'
            '   - Apply thermal paste to the CPU if needed.\n'
            '   - Attach the cooler to the CPU and secure it with the provided brackets.\n'
            '   - Connect the cooler’s power cable to the motherboard.\n'
            '3. Install the RAM into the RAM slots.\n'
            '   - Open the RAM slot levers.\n'
            '   - Align the RAM module with the slot and press down firmly until it clicks.\n'
            '4. Attach the storage devices (SSD/HDD).\n'
            '   - Place the storage devices into the appropriate bays or slots.\n'
            '   - Secure them with screws if needed.\n'
            '   - Connect the data and power cables to the storage devices.\n'
            '5. Connect the power supply to the motherboard, CPU, and other components.\n'
            '   - Attach the 24-pin ATX power connector to the motherboard.\n'
            '   - Connect the 8-pin CPU power connector.\n'
            '   - Connect power cables to the GPU, storage devices, and any additional components.\n'
            '6. Install the GPU into the PCI-E slot.\n'
            '   - Remove the corresponding backplate(s) on the case.\n'
            '   - Insert the GPU into the PCI-E slot and secure it with screws.\n'
            '   - Connect the GPU power cables.\n'
            '7. Connect all necessary cables (data, power, peripheral).\n'
            '   - Connect the case’s front panel connectors to the motherboard.\n'
            '   - Attach any additional peripherals and case fans.\n'
            '8. Double-check all connections and secure cables for good airflow.\n'
            '9. Power on the system and enter BIOS to check if all components are recognized.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
