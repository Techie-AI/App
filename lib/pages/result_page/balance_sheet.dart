import 'package:flutter/material.dart';

class BalanceSheet extends StatelessWidget {
  final double totalCost;
  final double initialBudget;
  final double remainingBudget;

  const BalanceSheet({
    super.key,
    required this.totalCost,
    required this.initialBudget,
    required this.remainingBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 0, 82, 150).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Sheet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Cost:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '₹$totalCost',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Initial Budget:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '₹$initialBudget',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                remainingBudget >= 0 ? 'Remaining Budget:' : 'Over Budget:',
                style: TextStyle(
                  fontSize: 18,
                  color: remainingBudget >= 0 ? Colors.green : Colors.red,
                ),
              ),
              Text(
                '₹$remainingBudget',
                style: TextStyle(
                  fontSize: 18,
                  color: remainingBudget >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
